-- 会員テーブル
CREATE TABLE User(
  UserNum BIGINT NOT NULL AUTO_INCREMENT, -- 会員番号
  FirstName NVARCHAR(64) NOT NULL, -- 氏名（姓）
  LastName NVARCHAR(64) NOT NULL, -- 氏名（名）
  YomiFirst NVARCHAR(128) NOT NULL, -- フリガナ（姓）
  YomiLast NVARCHAR(128) NOT NULL, -- フリガナ(名)
  Phone CHAR(11) NOT NULL, -- 電話番号(最大長11桁)
  Mail VARCHAR(256) NOT NULL, -- メールアドレス(ユーザ名+ドメイン名で最大長128)
  UserID VARCHAR(128) NOT NULL, -- ユーザID(半角英数字のみ)
  Password VARCHAR(512) NOT NULL, -- パスワード(password_hash();を利用した暗号化後のデータを保存)
  Birth DATE NOT NULL, -- 誕生日
  Gender BOOLEAN NOT NULL, -- 性別(true...男 false...女)
  ZipCode CHAR(8) NOT NULL, -- 郵便番号
  Pref NVARCHAR(16) NOT NULL, -- 都道府県
  City NVARCHAR(64) not NULL, -- 市区町村
  Address NVARCHAR(256) NOT NULL, -- 丁番地
  Apartment NVARCHAR(256) NOT NULL, -- 建物名・部屋番号
  PRIMARY KEY (UserNum),
  UNIQUE (Phone),
  UNIQUE (Mail),
  UNIQUE (UserID)
) ENGINE = InnoDB;

-- 店舗テーブル
CREATE TABLE Store(
  StoreNum INTEGER NOT NULL, -- 店舗番号
  StoreName NVARCHAR(128) NOT NULL,  -- 店舗名
  PRIMARY KEY (StoreNum)
) ENGINE = InnoDB;

-- 従業員テーブル
CREATE TABLE Staff(
  StaffNum INTEGER NOT NULL, -- 従業員番号
  StoreNum INTEGER NOT NULL, -- 店舗番号
  StaffName NVARCHAR(256) NOT NULL, -- 従業員名
  Position NVARCHAR(64), -- 役職
  PRIMARY KEY (StaffNum),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum)
) ENGINE = InnoDB;

-- 商品テーブル
CREATE TABLE Item(
  JANCode CHAR(13) NOT NULL, -- JANコード
  Price INTEGER NOT NULL, -- 単価
  Discount INTEGER, -- 割引額
  PRIMARY KEY (JANCode)
) ENGINE = InnoDB;

-- 書籍テーブル
CREATE TABLE Book(
  JANCode CHAR(13) NOT NULL, -- JANコード
  BookTitle NVARCHAR(256), -- 書籍名
  Writer NVARCHAR(256), -- 著者
  Publisher NVARCHAR(256), -- 出版社
  PRIMARY KEY (JANCode),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode)
) ENGINE = InnoDB;

-- 他商品テーブル
CREATE TABLE Other(
  JANCode CHAR(13) NOT NULL, -- JANコード
  Name NVARCHAR(256), -- 商品名
  Manufacturer NVARCHAR(256), -- メーカー
  Genre NVARCHAR(64), -- ジャンル
  PRIMARY KEY (JANCode),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode)
) ENGINE = InnoDB;

-- 在庫テーブル
CREATE TABLE Stock(
  JANCode CHAR(13) NOT NULL, -- JANコード
  StoreNum INTEGER NOT NULL, -- 店舗番号
  StockAmount INTEGER, -- 数量
  PRIMARY KEY (JANCode, StoreNum),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum)
) ENGINE = InnoDB;

-- 棚番号テーブル
CREATE TABLE Place(
  JANCode CHAR(13) NOT NULL, -- JANコード
  StoreNum INTEGER NOT NULL, -- 店舗番号
  PlaceNum Char(8), -- 棚番号(2F-12-A1みたいな)
  PRIMARY KEY (JANCode,StoreNum),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum)
) ENGINE = InnoDB;

-- 売上テーブル
CREATE TABLE Sale(
  SaleNum INTEGER NOT NULL AUTO_INCREMENT, -- 売上番号
  SaleDate DATETIME NOT NULL, -- 売上日
  StoreNum INTEGER NOT NULL, -- 店舗番号
  StaffNum INTEGER NOT NULL, -- 従業員番号
  Age INTEGER, -- 顧客年代
  PRIMARY KEY (SaleNum, SaleDate, StoreNum),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum),
  FOREIGN KEY (StaffNum) REFERENCES Staff(StaffNum)
) ENGINE = InnoDB;

-- 売上明細テーブル
CREATE TABLE SaleDetail(
  SaleNum INTEGER NOT NULL AUTO_INCREMENT, -- 売上番号
  SaleDate DATETIME NOT NULL, -- 売上日
  StoreNum INTEGER NOT NULL, -- 店舗番号
  SaleDetNum INTEGER NOT NULL, -- 売上明細番号
  JANCode CHAR(13) NOT NULL, -- JANコード
  Price INTEGER NOT NULL, -- 単価
  Discount INTEGER NOT NULL, -- 割引額
  PRIMARY KEY (SaleNum, SaleDate, StoreNum, SaleDetNum),
  FOREIGN KEY (SaleNum) REFERENCES Sale(SaleNum),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode)
) ENGINE = InnoDB;

-- 発注テーブル
CREATE TABLE Ordered(
  OrderNum BIGINT NOT NULL,
  StoreNum INTEGER NOT NULL,
  OrderPublisher NVARCHAR(256), -- 出版社名
  DeliveryStat TINYINT NOT NULL, -- 配送状況 0..未発送 1..発送済み 2..到着済み　3..検品済み
  PRIMARY KEY (OrderNum, StoreNum),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum)
) ENGINE = InnoDB;

-- 発注明細テーブル
CREATE TABLE OrderedDetail(
  OrderNum BIGINT NOT NULL, -- 発注番号
  StoreNum INTEGER NOT NULL, -- 店舗番号
  OrderDetNum INTEGER NOT NULL, -- 発注明細番号
  JANCode CHAR(13) NOT NULL, -- JANコード
  OrderAmount INTEGER NOT NULL, -- 数量
  PRIMARY KEY (OrderNum, StoreNum, OrderDetNum),
  FOREIGN KEY (OrderNum) REFERENCES Ordered(OrderNum),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode)
) ENGINE = InnoDB;

-- 返品テーブル
/*
  Create table 'Websysa7/#sql-6d6c_9' with foreign key constraint failed.
  There is no index in the referenced table where the referenced columns appear as the first columns.
  ってなる。とりあえず必須でもないので一時的に廃止
*/
# CREATE TABLE ReturnLimit(
#   OrderNum BIGINT NOT NULL, -- 発注番号
#   StoreNum INTEGER NOT NULL, -- 店舗番号
#   OrderDetNum INTEGER NOT NULL, -- 発注明細番号
#   ReturnDate DATE, -- 返品期限
#   PRIMARY KEY (OrderNum, StoreNum, OrderDetNum),
#   FOREIGN KEY (OrderNum) REFERENCES Ordered(OrderNum),
#   FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum),
#   FOREIGN KEY (OrderDetNum) REFERENCES OrderedDetail(OrderDetNum)
# ) ENGINE = InnoDB;

-- 注文テーブル
CREATE TABLE Request(
  RequestNum BIGINT NOT NULL, -- 注文番号
  StoreNum INTEGER NOT NULL, -- 店舗番号
  ReceiptLimit DATE, -- 受取期限
  ReceiptStat BOOLEAN, -- 受取状況(true..受取済 false..未受取)
  UserNum BIGINT, -- 会員番号
  Name NVARCHAR(256), -- 読者名
  Phone CHAR(11), -- 電話番号
  ZipCode CHAR(8), -- 郵便番号
  Pref NVARCHAR(16), -- 都道府県
  City NVARCHAR(64), -- 市区町村
  Address NVARCHAR(256), -- 丁番地
  Apartment NVARCHAR(256), -- 建物名・部屋番号
  PRIMARY KEY (RequestNum),
  FOREIGN KEY (StoreNum) REFERENCES Store(StoreNum),
  FOREIGN KEY (UserNum) REFERENCES User(UserNum)
) ENGINE = InnoDB;

-- 注文明細テーブル
CREATE TABLE RequestDetail(
  RequestNum BIGINT NOT NULL, -- 注文番号
  RequestDetNum INTEGER NOT NULL, -- 注文明細番号
  JANCode CHAR(13) NOT NULL, -- JANコード
  DeliveryStat TINYINT NOT NULL, -- 配送状況 0..未発送 1..発送済み 2..到着済
  PRIMARY KEY (RequestNum, RequestDetNum),
  FOREIGN KEY (RequestNum) REFERENCES Request(RequestNum),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode)
) ENGINE = InnoDB;

-- カートテーブル
CREATE TABLE Cart(
  UserNum BIGINT NOT NULL, -- 会員番号
  JANCode CHAR(13) NOT NULL, -- JANコード
  PRIMARY KEY (UserNum, JANCode),
  FOREIGN KEY (UserNum) REFERENCES User(UserNum),
  FOREIGN KEY (JANCode) REFERENCES Item(JANCode)
) ENGINE = InnoDB;
