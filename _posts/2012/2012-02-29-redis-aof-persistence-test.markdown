--- 
layout: post
title: !binary |
  cmVkaXMgYW9m5oyB5LmF5YyW55qE5LiA5Lqb5rWL6K+V

date: 2012-02-29 14:26:24 +08:00
---
AOF是否开启rewrite对数据插入基本没有影响，1M记录花了97s。
当内存达到100M时，自动触发rewrite:

    [1118] 28 Feb 14:49:58 - 1 clients connected (0 slaves), 103519224 bytes in use
    [1118] 28 Feb 14:49:59 * Starting automatic rewriting of AOF on 100% growth
    [1118] 28 Feb 14:49:59 * Background append only file rewriting started by pid 1125
    [1125] 28 Feb 14:50:02 * SYNC append only file rewrite performed
    [1118] 28 Feb 14:50:02 * Background AOF rewrite terminated with success
    [1118] 28 Feb 14:50:02 * Parent diff successfully flushed to the rewritten AOF (3955799 bytes)
    [1118] 28 Feb 14:50:02 * Background AOF rewrite successful
    [1118] 28 Feb 14:50:02 - Background AOF rewrite signal handler took 9403us

由于是纯插入操作，所以rewrite基本没有效果，两次的aof文件大小是相同的：

    -rw-r--r-- 1 root root 176000199 2012-02-28 14:54 /home/simon/appendonly.aof

比较redis启动时间，也差不多，都是39s。

这时如果重新执行脚本，对已经存在的1M记录进行set操作，耗时约125s。完成后又触发一次rewrite，这时就能看出差别了，aof文件大小还是176000199，压缩效果很明显。

但是即使压缩了，redis启动速度也很慢，如果单纯使用AOF，那么每次启动都需要重新load所有记录，1M就需要39s，如果是几千万，那么启动时间根本无法接受。

相比之下RDB持久化产生的dump文件大小要小很多，启动速度也很有优势。4M记录产生的rdb才20MB。

    root@simon-1:/home/simon# ll dump.rdb 
    -rw-r--r-- 1 root root 20545140 2012-02-28 17:45 dump.rdb

启动仅花费2s：

    [1817] 28 Feb 17:47:09 * DB loaded from disk: 2 seconds

rdb和aof都有明显的优缺点，如果能两种综合使用效果应该很好。例如，使用aof，并且每小时做一次snapshot，记录snapshot的时间点；在启动时先使用snapshot恢复数据，再根据aof进行重做；这样应该能大大缩短启动时间，并避免snapshot大数据库的开销。

参考资料：
- [Redis进阶教程-aof(append only file)日志文件](http://blog.nosqlfan.com/html/199.html?ref=rediszt)
- [对redis数据持久化的一些想法](href="http://www.yiihsia.com/2011/04/%E5%AF%B9redis%E6%95%B0%E6%8D%AE%E6%8C%81%E4%B9%85%E5%8C%96%E7%9A%84%E4%B8%80%E4%BA%9B%E6%83%B3%E6%B3%95/")
- [Redis内存容量的预估和优化](http://blog.nosqlfan.com/html/3430.html")
