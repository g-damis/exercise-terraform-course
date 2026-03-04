# Next.js CloudFront Image Demo

Demo minimale in `apps/web` per mostrare l'integrazione tra `next/image` e la pipeline immagini già presente nel repository:

CloudFront -> S3 transformed -> Lambda fallback -> S3 source

L'app usa un wrapper locale `CloudFrontImage` e un custom loader esplicito, senza passare da `/_next/image`.

## Prerequisiti

- Node.js installato
- una distribuzione CloudFront già creata da Terraform
- almeno una immagine già presente nel bucket source

## Configurazione

1. Dalla root del repository recupera il dominio CloudFront:

```bash
terraform output -raw cloudfront_domain_name
```

2. In `apps/web` crea `.env.local` partendo da `.env.example`:

```bash
NEXT_PUBLIC_IMAGE_CDN_BASE_URL=https://your-distribution.cloudfront.net
NEXT_PUBLIC_DEMO_IMAGE_PATH=/images/1.jpeg
```

`NEXT_PUBLIC_DEMO_IMAGE_PATH` deve puntare a una key realmente presente nel bucket source. Se la key non esiste, la pagina resta utile per la demo del wiring ma l'immagine non verrà caricata.

## Avvio locale

```bash
npm install
npm run dev
```

Poi apri `http://localhost:3000`.

## Cosa verificare in DevTools

- la pagina usa `next/image`
- le richieste immagine vanno al dominio CloudFront configurato
- le URL includono `format=auto`, `width`, `quality`
- non compare `/_next/image`
