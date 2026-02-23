**CloudFront Function** serve per normalizzare e trasformare querystring: path canonico (/original oppure /format=...,quality=...,width=...,height=...) così:
- aumenti cache hit
- la chiave S3 delle trasformate è deterministica

**S3 Transformed** è l’origin primario: se l’oggetto c’è, è super veloce.

Su 403, CloudFront fa origin failover verso Lambda Function URL.

La Lambda legge da S3 Original, trasforma con Sharp, salva su S3 Transformed, risponde e CloudFront fa chaching.