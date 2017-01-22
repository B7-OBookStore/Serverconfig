USE websysb7;

TRUNCATE TABLE Stock;

INSERT INTO Stock(JANCode,StoreNum) SELECT JANCode,1 FROM Item;
INSERT INTO Stock(JANCode,StoreNum) SELECT JANCode,2 FROM Item;
INSERT INTO Stock(JANCode,StoreNum) SELECT JANCode,3 FROM Item;
INSERT INTO Stock(JANCode,StoreNum) SELECT JANCode,4 FROM Item;
INSERT INTO Stock(JANCode,StoreNum) SELECT JANCode,5 FROM Item;
INSERT INTO Stock(JANCode,StoreNum) SELECT JANCode,6 FROM Item;

/* ランダムな在庫数を挿入 */
SET SQL_SAFE_UPDATES = 0;
UPDATE Stock SET StockAmount = FLOOR(RAND() * 100);

/* 戦え、白井先生！だけは多めに挿入　*/
UPDATE Stock SET StockAmount = FLOOR(RAND() * 20) + 100 WHERE JANCode = 9784775505045;