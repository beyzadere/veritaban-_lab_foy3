-- ONDOKUZ MAYIS ÜNİVERSİTESİ - BİLGİSAYAR MÜHENDİSLİĞİ
-- VERİ TABANI LABORATUVARI DENEY FÖYÜ-3 ÇÖZÜMLERİ

-- *********************************************************************************
-- BÖLÜM 1: VERİTABANI VE TABLO OLUŞTURMA (SORU 1)
-- *********************************************************************************

CREATE DATABASE SirketDB;
GO
USE SirketDB;
GO

-- 1. birimler tablosu oluşturma
CREATE TABLE birimler (
    birim_id INT PRIMARY KEY,
    birim_ad CHAR(25) NOT NULL
);
GO

-- 2. calisanlar tablosu oluşturma
CREATE TABLE calisanlar (
    calisan_id INT PRIMARY KEY,
    ad CHAR(25) NOT NULL,
    soyad CHAR(25) NOT NULL,
    maas INT NOT NULL,
    katilmaTarihi DATETIME NOT NULL,
    calisan_birim_id INT NOT NULL,
    CONSTRAINT FK_CalisanBirim FOREIGN KEY (calisan_birim_id)
        REFERENCES birimler(birim_id)
);
GO

-- 3. ikramiye tablosu oluşturma
CREATE TABLE ikramiye (
    ikramiye_calisan_id INT,
    ikramiye_ucret INT NOT NULL,
    ikramiye_tarih DATETIME NOT NULL,
    CONSTRAINT FK_IkramiyeCalisan FOREIGN KEY (ikramiye_calisan_id)
        REFERENCES calisanlar(calisan_id)
);
GO

-- 4. unvan tablosu oluşturma
CREATE TABLE unvan (
    unvan_calisan_id INT,
    unvan_calisan CHAR(25) NOT NULL,
    unvan_tarih DATETIME NOT NULL,
    CONSTRAINT FK_UnvanCalisan FOREIGN KEY (unvan_calisan_id)
        REFERENCES calisanlar(calisan_id)
);
GO

-- *********************************************************************************
-- BÖLÜM 2: TABLOLARA VERİ GİRİŞİ (SORU 2)
-- *********************************************************************************

-- birimler tablosuna veri girişi
INSERT INTO birimler (birim_id, birim_ad) VALUES (1, 'Yazılım');
INSERT INTO birimler (birim_id, birim_ad) VALUES (2, 'Donanım');
INSERT INTO birimler (birim_id, birim_ad) VALUES (3, 'Güvenlik');
GO

-- calisanlar tablosuna veri girişi
INSERT INTO calisanlar (calisan_id, ad, soyad, maas, katilmaTarihi, calisan_birim_id)
VALUES
(1, 'Ismail', 'İşeri', 100000, '2014-02-20', 1),
(2, 'Hami', 'Satılmış', 80000, '2014-06-11', 1),
(3, 'Durmuş', 'Şahin', 300000, '2014-02-20', 2),
(4, 'Kağan', 'Yazar', 500000, '2014-02-20', 3),
(5, 'Meryem', 'Soysaldı', 500000, '2014-06-11', 3),
(6, 'Duygu', 'Akşehir', 200000, '2014-06-11', 2),
(7, 'Kübra', 'Seyhan', 75000, '2014-01-20', 1),
(8, 'Gülcan', 'Yıldız', 90000, '2014-04-11', 3);
GO

-- ikramiye tablosuna veri girişi
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih)
VALUES
(1, 5000, '2016-02-20'),
(2, 3000, '2016-06-11'),
(3, 4000, '2016-02-20'),
(1, 4500, '2016-02-20'),
(2, 3500, '2016-06-11');
GO

-- unvan tablosuna veri girişi
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih)
VALUES
(1, 'Yönetici', '2016-02-20'),
(2, 'Personel', '2016-06-11'),
(8, 'Personel', '2016-06-11'),
(5, 'Müdür', '2016-06-11'),
(4, 'Yönetici Yardımcısı', '2016-06-11'),
(7, 'Personel', '2016-06-11'),
(6, 'Takım Lideri', '2016-06-11'),
(3, 'Takım Lideri', '2016-06-11');
GO

-- *********************************************************************************
-- BÖLÜM 3: UYGULAMA SORULARI (SORU 3-10)
-- *********************************************************************************

-- Soru 3: "Yazılım" veya "Donanım" birimlerinde çalışanların ad, soyad ve maaş bilgileri.
SELECT c.ad, c.soyad, c.maas FROM calisanlar c INNER JOIN birimler b ON c.calisan_birim_id = b.birim_id WHERE b.birim_ad IN ('Yazılım', 'Donanım');

-- Soru 4: Maaşı en yüksek olan çalışanların ad, soyad ve maaş bilgileri.
SELECT ad, soyad, maas FROM calisanlar WHERE maas = (SELECT MAX(maas) FROM calisanlar);

-- Soru 5: Birimlerin her birinde kaç adet çalışan olduğunu ve birimlerin isimleri.
SELECT b.birim_ad, COUNT(c.calisan_id) AS CalisanSayisi FROM birimler b INNER JOIN calisanlar c ON b.birim_id = c.calisan_birim_id GROUP BY b.birim_ad;

-- Soru 6: Birden fazla çalışana ait olan unvanların isimlerini ve o unvan altında çalışanların sayısı.
SELECT unvan_calisan, COUNT(unvan_calisan_id) AS CalisanSayisi FROM unvan GROUP BY unvan_calisan HAVING COUNT(unvan_calisan_id) > 1;

-- Soru 7: Maaşları "50000" ve "100000" arasında değişen çalışanların ad, soyad ve maaş bilgileri.
SELECT ad, soyad, maas FROM calisanlar WHERE maas BETWEEN 50000 AND 100000;

-- Soru 8: İkramiye hakkına sahip çalışanlara ait ad, soyad, birim, unvan ve ikramiye ücreti bilgileri.
SELECT c.ad, c.soyad, b.birim_ad, u.unvan_calisan, i.ikramiye_ucret FROM calisanlar c INNER JOIN ikramiye i ON c.calisan_id = i.ikramiye_calisan_id INNER JOIN birimler b ON c.calisan_birim_id = b.birim_id INNER JOIN unvan u ON c.calisan_id = u.unvan_calisan_id;

-- Soru 9: Ünvanı "Yönetici" ve "Müdür" olan çalışanların ad, soyad ve ünvanlarını.
SELECT c.ad, c.soyad, u.unvan_calisan FROM calisanlar c INNER JOIN unvan u ON c.calisan_id = u.unvan_calisan_id WHERE u.unvan_calisan IN ('Yönetici', 'Müdür');

-- Soru 10: Her birimde en yüksek maaş alan çalışanların ad, soyad ve maaş bilgileri.
SELECT c.ad, c.soyad, c.maas, b.birim_ad FROM calisanlar c INNER JOIN birimler b ON c.calisan_birim_id = b.birim_id INNER JOIN (SELECT calisan_birim_id, MAX(maas) AS MaxMaas FROM calisanlar GROUP BY calisan_birim_id) AS MaxMaaslar ON c.calisan_birim_id = MaxMaaslar.calisan_birim_id AND c.maas = MaxMaaslar.MaxMaas;