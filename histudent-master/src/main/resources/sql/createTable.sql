CREATE TABLE IF NOT EXISTS `user`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '用户编号',
    `stu_info_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '学生信息编号',
    `level` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '级别',  -- 0:普通用户 1-9:不同权限管理员
    `phone` CHAR(11) UNICODE NULL COMMENT '手机号',
    `password` VARCHAR(18) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(32) DEFAULT '无名' NOT NULL COMMENT '昵称',
    `age` TINYINT(3) UNSIGNED ZEROFILL NOT NULL DEFAULT 18 COMMENT '年龄',
    `sex` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别(0:secret 1:man 2:woman)',
    `version` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    PRIMARY KEY (`id`) -- 主键索引
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '用户表';

CREATE TABLE IF NOT EXISTS `school`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '学校编号',
    `name` varchar(30) NOT NULL COMMENT '学校名称',
    `version` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    PRIMARY KEY (`id`) -- 主键索引
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '学校表';

CREATE TABLE IF NOT EXISTS `departments`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '院系编号',
    `sch_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '学校编号',
    `name` VARCHAR(30) NOT NULL COMMENT '院系名称',
    `version` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '院系表';

CREATE TABLE IF NOT EXISTS `profession`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '专业编号',
    `dep_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '院系编号',
    `name` VARCHAR(30) NOT NULL COMMENT '专业名称',
    `version` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '专业表';

CREATE TABLE IF NOT EXISTS `user_course_scheduling`(
    `id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户课程排班编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    `course_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '课程编号',
    `course_type` TINYINT(1) UNSIGNED DEFAULT 0 NOT NULL COMMENT '课程类别',  -- 0: 理论课, 1: 实验课, 默认为0
    `is_exam` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否考试',   -- 0: 考试, 1: 考察, DEFAULT: 考试
    `classroom` VARCHAR(50) NOT NULL COMMENT '上课教室',
    `weekly` INTEGER UNSIGNED NOT NULL COMMENT '课程周次',  -- 第几周
    `row` INTEGER UNSIGNED NOT NULL COMMENT '课程节次',     -- 第几节
    `col` INTEGER UNSIGNED NOT NULL COMMENT '课程周号',     -- 周几
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '用户课程排班表';

CREATE TABLE IF NOT EXISTS `stu_info`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '学生编号',
    `stu_num` varchar(20) NOT NULL COMMENT '学号',
    `stu_name` varchar(20) NOT NULL COMMENT '姓名',
    `sch_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '学校编号',
    `dep_id` BIGINT(20) NOT NULL COMMENT '院系编号',
    `prof_id` BIGINT(20) NOT NULL COMMENT '专业编号',
    `grade` INTEGER UNSIGNED NOT NULL COMMENT '年级',
    `class` INTEGER UNSIGNED NOT NULL COMMENT '班级',
    `version_id` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    PRIMARY KEY (`id`),
    UNIQUE (stu_num, sch_id),
    CONSTRAINT stu_info_for_sch FOREIGN KEY(sch_id) REFERENCES school(id)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '学生信息表';

-- 这里需要做一个设定, 如果用户没有绑定学校不能使用跳蚤市场功能
CREATE TABLE IF NOT EXISTS `commodity`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '商品编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    `title` varchar(50) NOT NULL COMMENT '标题',
    `price` DECIMAL(5, 2) NOT NULL COMMENT '价格', -- 整数3位小数2位
    `count` INT UNSIGNED NOT NULL COMMENT '数量',
    `unit` VARCHAR(10) NOT NULL COMMENT '单位',
    `version` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    `gmt_create` TIMESTAMP NOT NULL COMMENT '创建时间',
    `gmt_modified` TIMESTAMP NOT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    CONSTRAINT commodity_for_user FOREIGN KEY(user_id) REFERENCES user(id)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '跳蚤市场商品表';

CREATE TABLE IF NOT EXISTS `file`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '文件编号',
    `type` TINYINT(1) UNSIGNED NOT NULL COMMENT '类别',
    `content_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '附件编号',
    `prefix` varchar(50) NOT NULL COMMENT '文件前缀',
    `suffix` varchar(10) NOT NULl COMMENT '文件后缀',
    `path` varchar(255) NOT NULL COMMENT '文件路径',
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '文件表';

-- 这里需要做一个设定, 如果用户没有绑定学校不能使用表白墙功能
CREATE TABLE IF NOT EXISTS `wall_post`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '帖子编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    `title` varchar(50) NOT NULL COMMENT '标题',
    `content` varchar(255) NOT NULL COMMENT '内容',
    `type` TINYINT(1) UNSIGNED NOT NULL COMMENT '类别',
    `like` INTEGER UNSIGNED NOT NULL DEFAULT 0 COMMENT '喜欢数量',
    `version` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '乐观锁',
    `gmt_create` TIMESTAMP NOT NULL COMMENT '创建时间',
    `gmt_modified` TIMESTAMP NOT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    CONSTRAINT wall_post_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '表白墙帖子表';

CREATE TABLE IF NOT EXISTS `wall_post_like`(
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    `wall_post_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '帖子编号',
    `gmt_create` TIMESTAMP NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`user_id`, `wall_post_id`),
    CONSTRAINT wall_post_like_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`),
    CONSTRAINT wall_post_like_for_wall_post FOREIGN KEY(`wall_post_id`) REFERENCES wall_post(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '表白墙帖子喜欢表';

CREATE TABLE IF NOT EXISTS `wall_post_comments`(
    `id` BIGINT(20) UNSIGNED NOT NULL COMMENT '评论编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    `wall_post_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '帖子编号',
    `content` VARCHAR(50) NOT NULL COMMENT '内容',    -- 限制50字符以内
    `gmt_create` TIMESTAMP NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    CONSTRAINT wall_post_comments_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`),
    CONSTRAINT wall_post_comments_for_wall_post FOREIGN KEY(`wall_post_id`) REFERENCES wall_post(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '表白墙帖子评论表';

CREATE TABLE IF NOT EXISTS `order`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '订单编号',
    `sch_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '学校编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '学生编号',  -- 购买者的编号(出售者编号在商品内有)
    `comm_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '商品编号',
    `count` INT UNSIGNED NOT NULL COMMENT '购买数量',
    `total_price` DECIMAL(5, 2) NOT NULL COMMENT '总价',
    PRIMARY KEY (`id`),
    CONSTRAINT order_for_sch FOREIGN KEY(`sch_id`) REFERENCES school(`id`),
    CONSTRAINT order_for_comm FOREIGN KEY(`comm_id`) REFERENCES commodity(`id`),
    CONSTRAINT order_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '订单表';

# 通知表
CREATE TABLE IF NOT EXISTS `notification`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '通知编号',
    `level` TINYINT(1) UNSIGNED NOT NULL COMMENT '级别',  -- 0:班级 1:院级 2:校级 3:组织
    `sch_id` BIGINT(20) UNSIGNED COMMENT '学校编号',
    `dep_id` BIGINT(20) UNSIGNED COMMENT '院系编号',
    `prof_id` BIGINT(20) UNSIGNED COMMENT '专业编号',
    `class_id` INTEGER UNSIGNED COMMENT '班级编号',
    `org_id` INTEGER UNSIGNED COMMENT '组织编号',
    `gmt_create` TIMESTAMP NOT NULL COMMENT '创建时间',
    `gmt_modified` TIMESTAMP NOT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    UNIQUE (sch_id, dep_id, prof_id, class_id)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '通知表';

CREATE TABLE IF NOT EXISTS `organization`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '组织编号',
    `originator` BIGINT(20) UNSIGNED NOT NULL COMMENT '发起人',
    `password` CHAR(5) COMMENT '组织密码',
    `name` VARCHAR(50) NOT NULL DEFAULT '未命名' COMMENT '组织名称',
    PRIMARY KEY (`id`),
    CONSTRAINT organization_for_user FOREIGN KEY(`originator`) REFERENCES user(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '组织表';

CREATE TABLE IF NOT EXISTS `user_organization`(
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '组织编号',
    `org_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '组织编号',
    PRIMARY KEY (`user_id`, `org_id`),
    CONSTRAINT user_organization_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`),
    CONSTRAINT user_organization_for_org FOREIGN KEY(`org_id`) REFERENCES organization(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '用户组织表';

CREATE TABLE IF NOT EXISTS `notification_collect`(
    `notif_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '通知编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    PRIMARY KEY (`notif_id`, `user_id`),
    CONSTRAINT notification_collect_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`),
    CONSTRAINT notification_collect_for_notif FOREIGN KEY(`notif_id`) REFERENCES notification(`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '通知收藏表';

CREATE TABLE IF NOT EXISTS `memo`(
    `id` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '备忘录编号',
    `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '用户编号',
    `memo` VARCHAR(255) NOT NULL COMMENT '备忘录内容',
    `gmt_create` TIMESTAMP NOT NULL COMMENT '创建时间',
    `gmt_modified` TIMESTAMP NOT NULL COMMENT '修改时间',
    CONSTRAINT user_memo_for_user FOREIGN KEY(`user_id`) REFERENCES user(`id`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '备忘录表';