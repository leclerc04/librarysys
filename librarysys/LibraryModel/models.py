from django.db import models
from datetime import datetime, timedelta

# Create your models here.

class Book(models.Model):
    isbn = models.CharField(max_length=20, unique=True, verbose_name='图书ISBN编号')
    title = models.CharField(max_length=255, verbose_name='图书标题')
    publisher = models.CharField(max_length=100, blank=True, null=True, verbose_name='出版社')
    publish_date = models.DateField(blank=True, null=True, verbose_name='出版日期')
    category = models.CharField(max_length=50, blank=True, null=True, verbose_name='图书分类')
    total_copies = models.IntegerField(default=0, verbose_name='总藏书量')
    available_copies = models.IntegerField(default=0, verbose_name='可借数量')
    location = models.CharField(max_length=100, blank=True, null=True, verbose_name='图书馆位置')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'books'
        verbose_name = '图书'
        verbose_name_plural = '图书'


class Author(models.Model):
    name = models.CharField(max_length=100, verbose_name='作者姓名')
    biography = models.TextField(blank=True, null=True, verbose_name='作者简介')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # 多对多关系，Django会自动创建中间表
    books = models.ManyToManyField(Book, through='BookAuthor', related_name='authors')

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'authors'
        verbose_name = '作者'
        verbose_name_plural = '作者'


class BookAuthor(models.Model):
    # 显式定义中间表，以便在需要时添加额外字段
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    author = models.ForeignKey(Author, on_delete=models.CASCADE)

    class Meta:
        db_table = 'book_authors'
        unique_together = ('book', 'author')
        verbose_name = '图书作者关联'
        verbose_name_plural = '图书作者关联'


class Reader(models.Model):
    GENDER_CHOICES = (
        ('男', '男'),
        ('女', '女'),
        ('未知', '未知'),
    )
    STATUS_CHOICES = (
        ('正常', '正常'),
        ('冻结', '冻结'),
    )
    
    reader_id = models.CharField(max_length=20, unique=True, verbose_name='读者证号')
    name = models.CharField(max_length=100, verbose_name='读者姓名')
    gender = models.CharField(max_length=4, choices=GENDER_CHOICES, default='未知', verbose_name='性别')
    phone = models.CharField(max_length=20, blank=True, null=True, verbose_name='联系电话')
    email = models.CharField(max_length=100, blank=True, null=True, verbose_name='电子邮箱')
    address = models.TextField(blank=True, null=True, verbose_name='家庭地址')
    register_date = models.DateField(verbose_name='注册日期')
    status = models.CharField(max_length=4, choices=STATUS_CHOICES, default='正常', verbose_name='读者状态')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.name}({self.reader_id})'

    class Meta:
        db_table = 'readers'
        verbose_name = '读者'
        verbose_name_plural = '读者'


class BorrowRecord(models.Model):
    STATUS_CHOICES = (
        ('已借出', '已借出'),
        ('已归还', '已归还'),
        ('逾期', '逾期'),
    )
    
    book = models.ForeignKey(Book, on_delete=models.CASCADE, verbose_name='图书')
    reader = models.ForeignKey(Reader, on_delete=models.CASCADE, verbose_name='读者')
    borrow_date = models.DateTimeField(default=datetime.now, verbose_name='借阅日期')
    due_date = models.DateField(verbose_name='应还日期')
    return_date = models.DateTimeField(blank=True, null=True, verbose_name='实际归还日期')
    status = models.CharField(max_length=4, choices=STATUS_CHOICES, default='已借出', verbose_name='借阅状态')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        # 如果未设置due_date，默认设置为借阅日期后30天
        if not self.due_date:
            self.due_date = (self.borrow_date + timedelta(days=30)).date()
        
        # 更新图书的可借数量
        if self.status == '已借出' and not self.return_date:
            if self.book.available_copies > 0:
                self.book.available_copies -= 1
                self.book.save()
        elif self.status == '已归还' and self.return_date:
            self.book.available_copies += 1
            self.book.save()
        
        # 检查是否逾期
        if self.status == '已借出' and datetime.now().date() > self.due_date:
            self.status = '逾期'
            self.save(update_fields=['status'])
        
        super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.reader.name} 借阅 {self.book.title}'

    class Meta:
        db_table = 'borrow_records'
        verbose_name = '借阅记录'
        verbose_name_plural = '借阅记录'