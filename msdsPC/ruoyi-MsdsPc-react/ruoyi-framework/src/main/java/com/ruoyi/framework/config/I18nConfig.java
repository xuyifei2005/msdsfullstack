package com.ruoyi.framework.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import com.ruoyi.common.constant.Constants;

/**
 * 资源文件配置加载
 * 
 * @author ruoyi
 */
@Configuration
public class I18nConfig implements WebMvcConfigurer
{
    @Bean
    public LocaleResolver localeResolver()
    {
        SessionLocaleResolver slr = new SessionLocaleResolver();
        // 默认语言
        slr.setDefaultLocale(Constants.DEFAULT_LOCALE);
        return slr;
    }

    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor()
    {
        LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
        // 参数名
        lci.setParamName("lang");
        return lci;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry)
    {
        registry.addInterceptor(localeChangeInterceptor());
    }
    
    /**
     * 配置MessageSource，支持多个国际化资源文件
     */
    @Bean
    public MessageSource messageSource()
    {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        // 设置多个资源文件基础名称
        messageSource.setBasenames(
            "classpath:i18n/messages",
            "classpath:i18n/msds_messages"
        );
        // 设置默认编码
        messageSource.setDefaultEncoding("UTF-8");
        // 设置缓存时间（秒），-1表示永久缓存
        messageSource.setCacheSeconds(3600);
        // 设置当找不到消息时是否使用消息键作为默认值
        messageSource.setUseCodeAsDefaultMessage(true);
        return messageSource;
    }
}
