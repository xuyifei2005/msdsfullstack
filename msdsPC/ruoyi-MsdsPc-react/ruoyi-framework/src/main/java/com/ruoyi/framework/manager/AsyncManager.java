package com.ruoyi.framework.manager;

import java.util.TimerTask;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import com.ruoyi.common.utils.Threads;
import com.ruoyi.common.utils.spring.SpringUtils;

/**
 * 异步任务管理器
 * 
 * @author ruoyi
 */
public class AsyncManager
{
    /**
     * 操作延迟10毫秒
     */
    private final int OPERATE_DELAY_TIME = 10;

    /**
     * 异步操作任务调度线程池
     */
    private volatile ScheduledExecutorService executor;

    /**
     * 单例模式
     */
    private AsyncManager(){}

    private static AsyncManager me = new AsyncManager();

    public static AsyncManager me()
    {
        return me;
    }

    /**
     * 获取线程池，延迟初始化
     */
    private ScheduledExecutorService getExecutor()
    {
        if (executor == null)
        {
            synchronized (this)
            {
                if (executor == null)
                {
                    try
                    {
                        executor = SpringUtils.getBean("scheduledExecutorService");
                    }
                    catch (Exception e)
                    {
                        // 如果获取Bean失败，说明Spring容器可能正在关闭，返回null
                        return null;
                    }
                }
            }
        }
        return executor;
    }

    /**
     * 执行任务
     * 
     * @param task 任务
     */
    public void execute(TimerTask task)
    {
        ScheduledExecutorService exec = getExecutor();
        if (exec != null && !exec.isShutdown())
        {
            exec.schedule(task, OPERATE_DELAY_TIME, TimeUnit.MILLISECONDS);
        }
    }

    /**
     * 停止任务线程池
     */
    public void shutdown()
    {
        if (executor != null && !executor.isShutdown())
        {
            Threads.shutdownAndAwaitTermination(executor);
        }
    }
}
