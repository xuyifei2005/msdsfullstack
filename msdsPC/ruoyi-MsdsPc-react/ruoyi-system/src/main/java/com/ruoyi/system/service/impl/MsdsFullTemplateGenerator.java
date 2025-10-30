package com.ruoyi.system.service.impl;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.*;

/**
 * MSDS完整模板生成器 - 包含16个章节所有字段
 * 
 * @author ruoyi
 */
@Service
public class MsdsFullTemplateGenerator {
    
    private static final Logger log = LoggerFactory.getLogger(MsdsFullTemplateGenerator.class);
    
    /**
     * 生成包含16章节完整字段的Excel模板
     */
    public byte[] generateFullTemplate() {
        log.info("开始生成MSDS完整模板（16章节）");
        
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            
            // 创建16个章节的Sheet
            create1ChemicalInfoSheet(workbook);       // 1. 化学品及企业标识
            create2HazardSheet(workbook);              // 2. 危险性概述
            create3ComponentSheet(workbook);           // 3. 成分/组成信息
            create4FirstAidSheet(workbook);            // 4. 急救措施
            create5FireFightingSheet(workbook);        // 5. 消防措施
            create6LeakResponseSheet(workbook);        // 6. 泄漏应急处理
            create7HandlingStorageSheet(workbook);     // 7. 操作处置与储存
            create8ExposureControlSheet(workbook);     // 8. 接触控制/个体防护
            create9PhysicalChemicalSheet(workbook);    // 9. 理化特性
            create10StabilityReactivitySheet(workbook); // 10. 稳定性和反应活性
            create11ToxicologicalSheet(workbook);      // 11. 毒理学信息
            create12EcologicalSheet(workbook);         // 12. 生态学信息
            create13DisposalSheet(workbook);           // 13. 废弃处置
            create14TransportationSheet(workbook);     // 14. 运输信息
            create15RegulatorySheet(workbook);         // 15. 法规信息
            create16OtherInfoSheet(workbook);          // 16. 其他信息
            
            // 添加使用说明Sheet
            createInstructionSheet(workbook);
            
            // 转换为字节数组
            try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                workbook.write(outputStream);
                byte[] result = outputStream.toByteArray();
                log.info("MSDS完整模板生成成功，大小: {} bytes", result.length);
                return result;
            }
            
        } catch (IOException e) {
            log.error("生成MSDS完整模板失败", e);
            throw new RuntimeException("生成模板失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 第1部分：化学品及企业标识
     */
    private void create1ChemicalInfoSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("1.化学品及企业标识");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "CAS号*", "MSDS编号*", "产品名称*", "产品别名", 
            "英文名称*", "分子式", "分子量", "供应商名称", "供应商地址",
            "联系电话", "应急电话", "传真号码", "电子邮箱", "网站地址",
            "创建时间", "更新时间", "备注"
        };
        
        String[] descriptions = {
            "自动生成，导入时留空", "CAS登记号(必填)", "MSDS文档编号(必填)", "化学品中文名称(必填)", 
            "多个别名用分号分隔", "化学品英文名称(必填)", "分子式，如C2H6O", "分子量，如46.07",
            "供应商或生产商名称", "供应商地址", "联系电话", "24小时应急电话", 
            "传真号码", "电子邮箱", "企业网站", "自动生成", "自动生成", "备注信息"
        };
        
        String[] examples = {
            "", "64-17-5", "MSDS#001", "乙醇", "酒精；无水乙醇", 
            "Ethanol", "C2H6O", "46.07", "XX化工有限公司", "北京市朝阳区xxx",
            "010-12345678", "400-999-8888", "010-12345679", "info@example.com", "www.example.com",
            "", "", "示例备注"
        };
        
        createDataSheet(sheet, styles, "第一部分：化学品及企业标识", headers, descriptions, examples);
        log.debug("创建Sheet: 1.化学品及企业标识");
    }
    
    /**
     * 第2部分：危险性概述
     */
    private void create2HazardSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("2.危险性概述");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "危险性类别", "GHS危险性类别", "象形图",
            "警示词", "危险性说明", "侵入途径", "健康危害", 
            "环境危害", "燃爆危险"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID(系统自动关联)", "如：第3.1类易燃液体", "GHS分类标准",
            "GHS象形图代码", "如：危险、警告", "危险性说明文本", "吸入、食入、经皮吸收等",
            "健康危害描述", "环境危害描述", "燃爆危险性描述"
        };
        
        String[] examples = {
            "", "", "第3.1类 易燃液体", "易燃液体类别2", "GHS02,GHS07",
            "危险", "高度易燃液体和蒸气", "吸入、食入、经皮吸收", 
            "本品为中枢神经系统抑制剂。首先引起兴奋，随后抑制。", 
            "对水生生物有轻微危害", "易燃，其蒸气与空气可形成爆炸性混合物"
        };
        
        createDataSheet(sheet, styles, "第二部分：危险性概述", headers, descriptions, examples);
        log.debug("创建Sheet: 2.危险性概述");
    }
    
    /**
     * 第3部分：成分/组成信息
     */
    private void create3ComponentSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("3.成分组成信息");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "成分名称*", "成分含量*", "CAS号",
            "EINECS号", "分子式", "分子量", "危险性分类"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "组分名称(必填)", "含量或浓度(必填，如99.5%)",
            "组分CAS号", "欧洲化学品编号", "组分分子式", "组分分子量", "组分危险性分类"
        };
        
        String[] examples = {
            "", "", "乙醇", "≥99.5%", "64-17-5",
            "200-578-6", "C2H6O", "46.07", "易燃液体类别2"
        };
        
        createDataSheet(sheet, styles, "第三部分：成分/组成信息", headers, descriptions, examples);
        log.debug("创建Sheet: 3.成分/组成信息");
    }
    
    /**
     * 第4部分：急救措施
     */
    private void create4FirstAidSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("4.急救措施");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "皮肤接触", "眼睛接触", "吸入", "食入", "医生须知"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "皮肤接触后急救措施", "眼睛接触后急救措施",
            "吸入后急救措施", "食入后急救措施", "对医护人员的特别提示"
        };
        
        String[] examples = {
            "", "", "脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤。", 
            "提起眼睑，用流动清水或生理盐水冲洗至少15分钟。就医。",
            "迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。",
            "饮足量温水，催吐。就医。",
            "无特殊要求"
        };
        
        createDataSheet(sheet, styles, "第四部分：急救措施", headers, descriptions, examples);
        log.debug("创建Sheet: 4.急救措施");
    }
    
    /**
     * 第5部分：消防措施
     */
    private void create5FireFightingSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("5.消防措施");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "危险特性", "有害燃烧产物", "灭火方法", 
            "灭火注意事项", "特别危险性"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "火灾危险特性描述", "燃烧时产生的有害物质",
            "适合的灭火剂和灭火方法", "灭火时的注意事项", "特殊火灾危险性"
        };
        
        String[] examples = {
            "", "", "易燃，其蒸气与空气可形成爆炸性混合物，遇明火、高热能引起燃烧爆炸。", 
            "一氧化碳、二氧化碳",
            "用抗溶性泡沫、干粉、二氧化碳、砂土灭火。",
            "尽可能将容器从火场移至空旷处。喷水保持火场容器冷却，直至灭火结束。",
            "蒸气比空气重，能在较低处扩散至远处，遇火源会着火回燃。"
        };
        
        createDataSheet(sheet, styles, "第五部分：消防措施", headers, descriptions, examples);
        log.debug("创建Sheet: 5.消防措施");
    }
    
    /**
     * 第6部分：泄漏应急处理
     */
    private void create6LeakResponseSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("6.泄漏应急处理");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "应急行动", "应急人员防护", "泄漏处理", 
            "环境保护措施"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "泄漏时的应急行动", "应急人员需采取的防护措施",
            "泄漏物的处理方法", "防止环境污染的措施"
        };
        
        String[] examples = {
            "", "", "消除所有点火源。根据液体流动和蒸气扩散的影响区域划定警戒区，无关人员从侧风、上风向撤离至安全区。", 
            "应急处理人员戴正压自给式呼吸器，穿防静电服。",
            "尽可能切断泄漏源。小量泄漏：用砂土或其他不燃材料吸附或吸收。也可以用大量水冲洗，洗水稀释后放入废水系统。大量泄漏：构筑围堤或挖坑收容。用泡沫覆盖，降低蒸气灾害。用防爆泵转移至槽车或专用收集器内，回收或运至废物处理场所处置。",
            "防止泄漏物进入水体、下水道、地下室或密闭性空间。"
        };
        
        createDataSheet(sheet, styles, "第六部分：泄漏应急处理", headers, descriptions, examples);
        log.debug("创建Sheet: 6.泄漏应急处理");
    }
    
    /**
     * 第7部分：操作处置与储存
     */
    private void create7HandlingStorageSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("7.操作处置与储存");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "操作注意事项", "储存注意事项", 
            "包装材料", "储存温度", "储存湿度"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "操作使用时的注意事项", "储存保管的注意事项",
            "适用的包装材料", "推荐储存温度", "推荐储存湿度"
        };
        
        String[] examples = {
            "", "", "密闭操作，全面通风。操作人员必须经过专门培训，严格遵守操作规程。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂、酸类、碱金属接触。", 
            "储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。保持容器密封。应与氧化剂、酸类、碱金属等分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备和合适的收容材料。",
            "小开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶(罐)外普通木箱。",
            "≤30℃",
            "≤80%"
        };
        
        createDataSheet(sheet, styles, "第七部分：操作处置与储存", headers, descriptions, examples);
        log.debug("创建Sheet: 7.操作处置与储存");
    }
    
    /**
     * 第8部分：接触控制/个体防护
     */
    private void create8ExposureControlSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("8.接触控制个体防护");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "职业接触限值", "中国MAC(mg/m³)", "美国TLV-TWA(mg/m³)",
            "美国TLV-STEL(mg/m³)", "前苏联MAC(mg/m³)", "监测方法", 
            "工程控制", "呼吸系统防护", "眼睛防护", "身体防护", "手防护", "其他防护"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "职业接触限值说明", "中国最高容许浓度", "美国时间加权平均",
            "美国短时间接触浓度", "前苏联最高容许浓度", "监测检测方法", 
            "工程控制措施", "呼吸防护要求", "眼睛防护要求", "身体防护要求", "手部防护要求", "其他防护措施"
        };
        
        String[] examples = {
            "", "", "见下方具体数值", "未制定标准", "1000",
            "未制定标准", "1000", "气相色谱法",
            "生产过程密闭，全面通风。", 
            "一般不需要特殊防护，高浓度接触时可佩戴过滤式防毒面具（半面罩）。",
            "一般不需要特殊防护，高浓度接触时可戴化学安全防护眼镜。",
            "穿防静电工作服。",
            "戴一般作业防护手套。",
            "工作现场严禁吸烟。注意个人清洁卫生。进行就业前和定期的体检。"
        };
        
        createDataSheet(sheet, styles, "第八部分：接触控制/个体防护", headers, descriptions, examples);
        log.debug("创建Sheet: 8.接触控制/个体防护");
    }
    
    /**
     * 第9部分：理化特性
     */
    private void create9PhysicalChemicalSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("9.理化特性");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "外观与性状", "气味", "pH值", "熔点(℃)",
            "沸点(℃)", "闪点(℃)", "爆炸上限%(V/V)", "爆炸下限%(V/V)",
            "蒸气压(kPa)", "相对密度(水=1)", "相对蒸气密度(空气=1)", "饱和蒸气压(kPa)",
            "临界温度(℃)", "临界压力(MPa)", "辛醇/水分配系数", "燃烧热(kJ/mol)",
            "自燃温度(℃)", "分解温度(℃)", "溶解性", "黏度(mPa·s)", "分子式", "分子量"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "外观和物理状态", "气味描述", "酸碱度", "熔点温度",
            "沸点温度", "闪点温度", "爆炸上限", "爆炸下限", 
            "蒸气压强", "相对密度", "相对蒸气密度", "饱和蒸气压",
            "临界温度", "临界压力", "辛醇水分配系数", "燃烧热",
            "自燃温度", "分解温度", "溶解性描述", "黏度", "分子式", "分子量"
        };
        
        String[] examples = {
            "", "", "无色透明液体", "有酒香气味", "7.0", "-114.1",
            "78.3", "13", "19.0", "3.3",
            "5.33(19℃)", "0.79", "1.59", "5.33",
            "243.1", "6.38", "0.32", "1365.5",
            "363", "无资料", "与水混溶，可混溶于醚、氯仿、甘油等多数有机溶剂", "1.074(20℃)", "C2H6O", "46.07"
        };
        
        createDataSheet(sheet, styles, "第九部分：理化特性", headers, descriptions, examples);
        log.debug("创建Sheet: 9.理化特性");
    }
    
    /**
     * 第10部分：稳定性和反应活性
     */
    private void create10StabilityReactivitySheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("10.稳定性和反应活性");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "稳定性", "禁配物", "避免接触的条件", 
            "聚合危害", "分解产物"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "稳定性描述", "不能接触或混合的物质", "应避免的外部条件",
            "聚合反应危险性", "可能的分解产物"
        };
        
        String[] examples = {
            "", "", "稳定", "强氧化剂、酸类、酸酐、碱金属、胺类", "明火、高热、静电、强氧化剂",
            "不聚合", "一氧化碳、二氧化碳"
        };
        
        createDataSheet(sheet, styles, "第十部分：稳定性和反应活性", headers, descriptions, examples);
        log.debug("创建Sheet: 10.稳定性和反应活性");
    }
    
    /**
     * 第11部分：毒理学信息
     */
    private void create11ToxicologicalSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("11.毒理学信息");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "急性毒性", "LD50(mg/kg)", "LC50(mg/m³)",
            "刺激性", "致敏性", "致突变性", "致畸性", "致癌性", "其他"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "急性毒性描述", "半数致死剂量", "半数致死浓度",
            "刺激性数据", "致敏性数据", "致突变性数据", "致畸性数据", "致癌性数据", "其他毒理学信息"
        };
        
        String[] examples = {
            "", "", "属中等毒性", "大鼠经口LD50: 7060mg/kg; 兔经皮LD50: 7340mg/kg", "大鼠吸入LC50: 37620mg/m³, 10小时",
            "家兔经眼: 500mg, 重度刺激。家兔经皮: 15mg/24小时，轻度刺激。",
            "无资料", "无资料", "无资料", "无资料", "无资料"
        };
        
        createDataSheet(sheet, styles, "第十一部分：毒理学信息", headers, descriptions, examples);
        log.debug("创建Sheet: 11.毒理学信息");
    }
    
    /**
     * 第12部分：生态学信息
     */
    private void create12EcologicalSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("12.生态学信息");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "生态毒性", "生物降解性", "生物富集性", 
            "土壤迁移性", "其他有害作用"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "对水生生物等的毒性", "生物降解性能", "生物富集或累积性",
            "在土壤中的迁移性", "其他环境影响"
        };
        
        String[] examples = {
            "", "", "无资料", "可生物降解", "低生物富集性",
            "无资料", "该物质对环境可能有危害，在地下水中有蓄积作用。"
        };
        
        createDataSheet(sheet, styles, "第十二部分：生态学信息", headers, descriptions, examples);
        log.debug("创建Sheet: 12.生态学信息");
    }
    
    /**
     * 第13部分：废弃处置
     */
    private void create13DisposalSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("13.废弃处置");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "废弃物性质", "废弃处置方法", "废弃注意事项"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "废弃物的危险性质", "推荐的处置方法", "处置时的注意事项"
        };
        
        String[] examples = {
            "", "", "危险废物", "用焚烧法处置。", "处置前应参阅国家和地方有关法规。"
        };
        
        createDataSheet(sheet, styles, "第十三部分：废弃处置", headers, descriptions, examples);
        log.debug("创建Sheet: 13.废弃处置");
    }
    
    /**
     * 第14部分：运输信息
     */
    private void create14TransportationSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("14.运输信息");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "危险货物编号", "UN编号", "包装标志",
            "包装类别", "包装方法", "运输注意事项"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "危险货物编号", "联合国危险货物编号", "包装上的标志",
            "包装类别（I, II, III）", "包装方法描述", "运输时的注意事项"
        };
        
        String[] examples = {
            "", "", "32061", "1170", "7",
            "II", "小开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶(罐)外普通木箱。",
            "运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽(罐)车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、酸类、碱金属、食用化学品等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源、高温区。装运该物品的车辆排气管必须配备阻火装置，禁止使用易产生火花的机械设备和工具装卸。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。铁路运输时要禁止溜放。严禁用木船、水泥船散装运输。"
        };
        
        createDataSheet(sheet, styles, "第十四部分：运输信息", headers, descriptions, examples);
        log.debug("创建Sheet: 14.运输信息");
    }
    
    /**
     * 第15部分：法规信息
     */
    private void create15RegulatorySheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("15.法规信息");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "化学品安全技术说明书编写规定", "危险化学品安全管理条例",
            "工作场所安全使用化学品规定", "其他法规信息"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "GB/T 16483-2008", "国务院令第591号",
            "劳部发[1996]423号", "其他相关法规"
        };
        
        String[] examples = {
            "", "", "GB/T 16483-2008", "第591号", 
            "劳部发[1996]423号", "无"
        };
        
        createDataSheet(sheet, styles, "第十五部分：法规信息", headers, descriptions, examples);
        log.debug("创建Sheet: 15.法规信息");
    }
    
    /**
     * 第16部分：其他信息
     */
    private void create16OtherInfoSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("16.其他信息");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        String[] headers = {
            "ID*", "MSDS主信息ID*", "参考文献", "修订说明", "其他信息", "填表时间", "数据审核单位"
        };
        
        String[] descriptions = {
            "自动生成", "关联主信息ID", "参考的文献资料", "修订历史说明", "其他补充信息",
            "填表日期", "审核单位名称"
        };
        
        String[] examples = {
            "", "", "《危险化学品安全技术全书》、《化学品安全说明书编写指南》", 
            "初次编制", "无", "2024-01-01", "XX化工安全技术中心"
        };
        
        createDataSheet(sheet, styles, "第十六部分：其他信息", headers, descriptions, examples);
        log.debug("创建Sheet: 16.其他信息");
    }
    
    /**
     * 创建使用说明Sheet
     */
    private void createInstructionSheet(XSSFWorkbook workbook) {
        Sheet sheet = workbook.createSheet("使用说明");
        Map<String, CellStyle> styles = createStyles(workbook);
        
        int rowIndex = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowIndex++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("MSDS数据导入模板使用说明");
        titleCell.setCellStyle(styles.get("title"));
        titleRow.setHeight((short) 800);
        
        rowIndex++; // 空行
        
        // 说明内容
        String[] instructions = {
            "【模板说明】",
            "本模板包含MSDS标准的16个章节，每个章节对应一个工作表。",
            "",
            "【填写规则】",
            "1. 带*号的字段为必填项，请务必填写",
            "2. ID和时间类字段会自动生成，导入时留空即可",
            "3. 关联字段（如MSDS主信息ID）由系统自动关联，无需手填",
            "4. 每个工作表的第1行为标题，第2行为表头，第3行为字段说明，第4行为示例数据",
            "5. 从第5行开始填写实际数据",
            "",
            "【数据格式要求】",
            "• 日期格式：yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
            "• 数值字段：填写纯数字，不要包含单位",
            "• CAS号格式：xx-xx-x 或 xxx-xx-x",
            "• 百分比：直接填写数值+%，如99.5%",
            "• 多值字段：使用分号(;)分隔，如\"别名1;别名2;别名3\"",
            "",
            "【导入步骤】",
            "1. 下载本模板",
            "2. 按照格式要求填写各章节数据",
            "3. 第1章节（化学品及企业标识）为主表，必须填写",
            "4. 其他章节根据实际情况选择性填写",
            "5. 保存为Excel格式（.xlsx）",
            "6. 在系统中选择\"导入MSDS文档\"，上传填写好的Excel文件",
            "",
            "【注意事项】",
            "• 请勿修改表头行和字段说明行",
            "• 同一化学品的不同章节数据请保持CAS号一致",
            "• 导入前请检查数据完整性和格式正确性",
            "• 建议先导入少量数据进行测试",
            "",
            "【技术支持】",
            "如遇到问题，请联系系统管理员",
            "邮箱：support@example.com",
            "电话：XXX-XXXX-XXXX"
        };
        
        for (String instruction : instructions) {
            Row row = sheet.createRow(rowIndex++);
            Cell cell = row.createCell(0);
            
            if (instruction.startsWith("【")) {
                cell.setCellValue(instruction);
                cell.setCellStyle(styles.get("header"));
                row.setHeight((short) 400);
            } else {
                cell.setCellValue(instruction);
            }
        }
        
        // 设置列宽
        sheet.setColumnWidth(0, 20000);
        
        log.debug("创建Sheet: 使用说明");
    }
    
    /**
     * 创建数据Sheet的通用方法
     */
    private void createDataSheet(Sheet sheet, Map<String, CellStyle> styles, 
                                 String title, String[] headers, String[] descriptions, String[] examples) {
        // 第1行：标题
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) 600);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue(title);
        titleCell.setCellStyle(styles.get("title"));
        if (headers.length > 1) {
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, headers.length - 1));
        }
        
        // 第2行：表头
        Row headerRow = sheet.createRow(1);
        headerRow.setHeight((short) 400);
        
        // 第3行：字段说明
        Row descRow = sheet.createRow(2);
        descRow.setHeight((short) 350);
        
        // 第4行：示例数据
        Row exampleRow = sheet.createRow(3);
        exampleRow.setHeight((short) 350);
        
        for (int i = 0; i < headers.length; i++) {
            // 设置列宽
            sheet.setColumnWidth(i, 4500);
            
            // 表头
            Cell headerCell = headerRow.createCell(i);
            headerCell.setCellValue(headers[i]);
            headerCell.setCellStyle(styles.get("header"));
            
            // 说明
            Cell descCell = descRow.createCell(i);
            descCell.setCellValue(descriptions[i]);
            descCell.setCellStyle(styles.get("description"));
            
            // 示例
            Cell exampleCell = exampleRow.createCell(i);
            exampleCell.setCellValue(examples[i]);
            exampleCell.setCellStyle(styles.get("example"));
        }
        
        // 冻结前4行
        sheet.createFreezePane(0, 4);
    }
    
    /**
     * 创建Excel样式
     */
    private Map<String, CellStyle> createStyles(XSSFWorkbook workbook) {
        Map<String, CellStyle> styles = new HashMap<>();
        
        // 标题样式
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        titleFont.setColor(IndexedColors.WHITE.getIndex());
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        titleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorder(titleStyle);
        styles.put("title", titleStyle);
        
        // 表头样式
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 10);
        headerStyle.setFont(headerFont);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setWrapText(true);
        setBorder(headerStyle);
        styles.put("header", headerStyle);
        
        // 说明样式
        CellStyle descStyle = workbook.createCellStyle();
        Font descFont = workbook.createFont();
        descFont.setFontHeightInPoints((short) 9);
        descFont.setColor(IndexedColors.DARK_BLUE.getIndex());
        descStyle.setFont(descFont);
        descStyle.setAlignment(HorizontalAlignment.LEFT);
        descStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        descStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        descStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        descStyle.setWrapText(true);
        setBorder(descStyle);
        styles.put("description", descStyle);
        
        // 示例样式
        CellStyle exampleStyle = workbook.createCellStyle();
        Font exampleFont = workbook.createFont();
        exampleFont.setFontHeightInPoints((short) 9);
        exampleFont.setColor(IndexedColors.DARK_GREEN.getIndex());
        exampleFont.setItalic(true);
        exampleStyle.setFont(exampleFont);
        exampleStyle.setAlignment(HorizontalAlignment.LEFT);
        exampleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        exampleStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        exampleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        exampleStyle.setWrapText(true);
        setBorder(exampleStyle);
        styles.put("example", exampleStyle);
        
        return styles;
    }
    
    /**
     * 设置边框
     */
    private void setBorder(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
    }
}

