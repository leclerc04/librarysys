-- 创建图书表
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE COMMENT '图书ISBN编号',
    title VARCHAR(255) NOT NULL COMMENT '图书标题',
    publisher VARCHAR(100) COMMENT '出版社',
    publish_date DATE COMMENT '出版日期',
    category VARCHAR(50) COMMENT '图书分类',
    total_copies INT NOT NULL DEFAULT 0 COMMENT '总藏书量',
    available_copies INT NOT NULL DEFAULT 0 COMMENT '可借数量',
    location VARCHAR(100) COMMENT '图书馆位置',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建作者表
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '作者姓名',
    biography TEXT COMMENT '作者简介',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建图书-作者关联表（多对多关系）
CREATE TABLE book_authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL COMMENT '图书ID',
    author_id INT NOT NULL COMMENT '作者ID',
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE,
    UNIQUE KEY unique_book_author (book_id, author_id) COMMENT '确保图书和作者的关联唯一'
);

-- 创建读者表
CREATE TABLE readers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reader_id VARCHAR(20) NOT NULL UNIQUE COMMENT '读者证号',
    name VARCHAR(100) NOT NULL COMMENT '读者姓名',
    gender ENUM('男', '女', '未知') DEFAULT '未知' COMMENT '性别',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '电子邮箱',
    address TEXT COMMENT '家庭地址',
    register_date DATE NOT NULL COMMENT '注册日期',
    status ENUM('正常', '冻结') DEFAULT '正常' COMMENT '读者状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建借阅记录表
CREATE TABLE borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL COMMENT '图书ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    borrow_date DATETIME NOT NULL COMMENT '借阅日期',
    due_date DATE NOT NULL COMMENT '应还日期',
    return_date DATETIME COMMENT '实际归还日期',
    status ENUM('已借出', '已归还', '逾期') DEFAULT '已借出' COMMENT '借阅状态',
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (reader_id) REFERENCES readers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 插入图书数据
INSERT INTO books (isbn, title, publisher, publish_date, category, total_copies, available_copies, location, created_at, updated_at) VALUES
('9787536692930', '三体', '重庆出版社', '2008-01-01', '科幻小说', 5, 4, '科幻区 A架-01号', '2008-01-01 12:00:00', '2008-01-01 12:00:00'),
('9787544258607', '活着', '南海出版公司', '2012-08-01', '当代文学', 8, 7, '文学区 B架-03号', '2012-08-01 12:00:00', '2012-08-01 12:00:00'),
('9787544258614', '百年孤独', '南海出版公司', '2011-06-01', '外国文学', 6, 6, '文学区 C架-11号', '2011-06-01 12:00:00', '2011-06-01 12:00:00'),
('9787115417305', 'Python从入门到实践', '人民邮电出版社', '2016-07-01', '计算机技术', 10, 8, '科技区 D架-05号', '2016-07-01 12:00:00', '2016-07-01 12:00:00'),
('9787020138920', '解忧杂货店', '南海出版公司', '2017-05-01', '当代文学', 12, 12, '文学区 B架-04号', '2017-05-01 12:00:00', '2017-05-01 12:00:00'),
('9787111634589', '深度学习', '机械工业出版社', '2019-09-01', '计算机技术', 7, 6, '科技区 D架-06号', '2019-09-01 12:00:00', '2019-09-01 12:00:00');

-- 插入作者数据
INSERT INTO authors (name, biography, created_at, updated_at) VALUES
('刘慈欣', '中国当代科幻小说的主要代表作家，被誉为中国科幻的领军人物。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('余华', '中国当代著名作家，浙江海盐人，代表作有《活着》、《许三观卖血记》等。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('加西亚·马尔克斯', '哥伦比亚著名作家、记者和社会活动家，拉丁美洲魔幻现实主义文学的代表人物，1982年诺贝尔文学奖得主。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('埃里克·马瑟斯', '（Eric Matthes）美国高中科学和数学教师，热衷于编写有趣的程序项目。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('东野圭吾', '日本著名推理小说家，代表作有《白夜行》、《嫌疑人X的献身》、《解忧杂货店》等。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('伊恩·古德费洛', '（Ian Goodfellow）是生成对抗网络（GANs）的发明者之一，是深度学习领域的杰出研究者。', '2024-01-01 10:00:00', '2024-01-01 10:00:00');


-- 插入图书-作者关联数据
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- 三体 -> 刘慈欣
(2, 2), -- 活着 -> 余华
(3, 3), -- 百年孤独 -> 加西亚·马尔克斯
(4, 4), -- Python从入门到实践 -> 埃里克·马瑟斯
(5, 5), -- 解忧杂货店 -> 东野圭吾
(6, 6); -- 深度学习 -> 伊恩·古德费洛

-- 插入读者数据
INSERT INTO readers (reader_id, name, gender, phone, email, address, register_date, status, created_at, updated_at) VALUES
('R001', '张三', '男', '13800138000', 'zhangsan@example.com', '北京市朝阳区幸福大街1号', '2024-01-15', '正常', '2024-01-15 09:30:00', '2024-01-15 09:30:00'),
('R002', '李四', '女', '13900139000', 'lisi@example.com', '上海市浦东新区世纪大道2号', '2024-03-22', '正常', '2024-03-22 11:00:00', '2024-03-22 11:00:00'),
('R003', '王五', '男', '13700137000', 'wangwu@example.com', '广东省深圳市南山区科技路3号', '2023-11-10', '冻结', '2023-11-10 14:00:00', '2023-11-10 14:00:00'),
('R004', '赵六', '女', '13600136000', 'zhaoliu@example.com', '浙江省杭州市西湖区文三路4号', '2024-05-20', '正常', '2024-05-20 16:20:00', '2024-05-20 16:20:00'),
('R005', '孙七', '男', '13500135000', 'sunqi@example.com', '四川省成都市高新区天府大道5号', '2024-07-01', '正常', '2024-07-01 10:15:00', '2024-07-01 10:15:00');


-- 插入借阅记录数据
-- 假设当前日期是 2025-09-28
-- 记录1: 张三借阅《活着》，已逾期
INSERT INTO borrow_records (book_id, reader_id, borrow_date, due_date, return_date, status, created_at, updated_at) VALUES
(2, 1, '2025-08-10 10:00:00', '2025-09-09', NULL, '逾期', '2025-08-10 10:00:00', '2025-09-28 09:00:00'),
-- 记录2: 李四借阅《Python从入门到实践》，正常借出
(4, 2, '2025-09-01 14:30:00', '2025-10-01', NULL, '已借出', '2025-09-01 14:30:00', '2025-09-01 14:30:00'),
-- 记录3: 张三曾借阅《三体》，已按时归还
(1, 1, '2025-07-05 09:00:00', '2025-08-04', '2025-07-28 16:00:00', '已归还', '2025-07-05 09:00:00', '2025-07-28 16:00:00'),
-- 记录4: 王五（状态冻结）曾借阅《百年孤独》，已归还
(3, 3, '2025-06-15 11:00:00', '2025-07-15', '2025-07-10 18:00:00', '已归还', '2025-06-15 11:00:00', '2025-07-10 18:00:00'),
-- 记录5: 赵六借阅《深度学习》，正常借出
(6, 4, '2025-09-10 15:00:00', '2025-10-10', NULL, '已借出', '2025-09-10 15:00:00', '2025-09-10 15:00:00'),
-- 记录6: 李四又借阅了《Python从入门到实践》，但是已经归还
(4, 2, '2025-05-01 14:30:00', '2025-06-01', '2025-05-25 11:45:00', '已归还', '2025-05-01 14:30:00', '2025-05-25 11:45:00');

