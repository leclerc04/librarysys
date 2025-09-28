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
