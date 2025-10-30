package com.ruoyi.framework.config;

import java.util.TimeZone;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import com.ruoyi.system.service.IMsdsMetadataService;
import com.ruoyi.system.service.impl.MsdsMetadataServiceImpl;
import com.ruoyi.system.service.IRuleMapperService;
import com.ruoyi.system.service.impl.RuleMapperServiceImpl;
import com.ruoyi.system.service.IMsdsTemplateXlsxWriter;
import com.ruoyi.system.service.impl.MsdsTemplateXlsxWriterImpl;

/**
 * 程序注解配置
 *
 * @author ruoyi
 */
@Configuration
// 表示通过aop框架暴露该代理对象,AopContext能够访问
@EnableAspectJAutoProxy(exposeProxy = true)
// 指定要扫描的Mapper类的包的路径
@MapperScan("com.ruoyi.**.mapper")
public class ApplicationConfig
{
    /**
     * 时区配置
     */
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jacksonObjectMapperCustomization()
    {
        return jacksonObjectMapperBuilder -> jacksonObjectMapperBuilder.timeZone(TimeZone.getDefault());
    }
    
    /**
     * MSDS元数据服务
     */
    @Bean
    public IMsdsMetadataService msdsMetadataService()
    {
        return new MsdsMetadataServiceImpl();
    }
    
    /**
     * 规则映射服务
     */
    @Bean
    public IRuleMapperService ruleMapperService()
    {
        return new RuleMapperServiceImpl();
    }
    
    // Excel模板写出器已通过@Service注解自动注册，无需手动配置
}
