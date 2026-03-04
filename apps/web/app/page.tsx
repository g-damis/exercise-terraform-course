import { CloudFrontImage } from "@/components/cloudfront-image";
import {
  DEFAULT_IMAGE_QUALITY,
  DEFAULT_IMAGE_SIZES,
  buildCloudFrontImageUrl,
  normalizeCloudFrontPath,
} from "@/lib/cloudfront-image-loader";

import styles from "./page.module.css";

const SAMPLE_REQUEST_WIDTH = 1280;

function validateBaseUrl(baseUrl: string | undefined) {
  if (!baseUrl) {
    return null;
  }

  try {
    return new URL(baseUrl).toString();
  } catch {
    return null;
  }
}

export default function HomePage() {
  const configuredBaseUrl = process.env.NEXT_PUBLIC_IMAGE_CDN_BASE_URL?.trim();
  const configuredImagePath = process.env.NEXT_PUBLIC_DEMO_IMAGE_PATH?.trim();

  const missingEnvVars = [
    !configuredBaseUrl && "NEXT_PUBLIC_IMAGE_CDN_BASE_URL",
    !configuredImagePath && "NEXT_PUBLIC_DEMO_IMAGE_PATH",
  ].filter(Boolean) as string[];

  const validBaseUrl = validateBaseUrl(configuredBaseUrl);

  if (missingEnvVars.length > 0 || !validBaseUrl) {
    return (
      <main className={styles.page}>
        <div className={`${styles.shell} ${styles.noticeWrap}`}>
          <section className={styles.notice}>
            <p className={styles.eyebrow}>Configuration required</p>
            <h1 className={styles.noticeTitle}>
              Configurazione demo immagini non completa
            </h1>
            <p className={styles.noticeText}>
              La pagina richiede le variabili pubbliche usate dal loader
              CloudFront. Aggiorna <code>apps/web/.env.local</code> e riavvia il
              server di sviluppo.
            </p>
            {missingEnvVars.length > 0 ? (
              <ul className={styles.missingList}>
                {missingEnvVars.map((envVar) => (
                  <li key={envVar} className={styles.missingItem}>
                    {envVar}
                  </li>
                ))}
              </ul>
            ) : null}
            {!validBaseUrl && configuredBaseUrl ? (
              <p className={styles.noticeText}>
                <code>NEXT_PUBLIC_IMAGE_CDN_BASE_URL</code> deve essere una URL
                assoluta valida, ad esempio{" "}
                <code>https://example.cloudfront.net</code>.
              </p>
            ) : null}
            <p className={styles.hint}>
              Per ottenere il dominio corretto, esegui dalla root del repo:
              <code> terraform output -raw cloudfront_domain_name</code>
            </p>
          </section>
        </div>
      </main>
    );
  }

  const demoImagePath = normalizeCloudFrontPath(configuredImagePath!);
  const exampleUrl = buildCloudFrontImageUrl({
    src: demoImagePath,
    width: SAMPLE_REQUEST_WIDTH,
    quality: DEFAULT_IMAGE_QUALITY,
    baseUrl: validBaseUrl,
  });

  return (
    <main className={styles.page}>
      <div className={styles.shell}>
        <section className={styles.hero}>
          <article className={styles.copy}>
            <p className={styles.eyebrow}>Next.js + CloudFront</p>
            <h1 className={styles.title}>Image optimization</h1>
            <p className={styles.subtitle}>
              Questa pagina usa <code>next/image</code> con un custom loader che
              punta direttamente al dominio CloudFront creato da Terraform. La
              pipeline CloudFront -&gt; S3 transformed -&gt; Lambda fallback -&gt; S3
              source resta visibile anche dal browser.
            </p>
          </article>

          <section className={styles.visual}>
            <div className={styles.visualMeta}>
              <span className={styles.chip}>format=auto</span>
              <span className={styles.chip}>quality={DEFAULT_IMAGE_QUALITY}</span>
              <span className={styles.chip}>responsive widths</span>
            </div>
            <div className={styles.imageStage}>
              <CloudFrontImage
                src={demoImagePath}
                alt="Demo image ottimizzata tramite CloudFront e Lambda"
                fill
                className={styles.image}
              />
            </div>
          </section>
        </section>

        <section className={styles.infoPanel}>
          <h2 className={styles.infoHeader}>Flow di integrazione</h2>
          <p className={styles.infoBody}>
            In DevTools vedrai richieste verso CloudFront, non verso{" "}
            <code>/_next/image</code>. Il parametro <code>width</code> cambia in
            base al viewport; l&apos;URL di esempio sotto mostra la stessa forma
            generata dal loader per una richiesta desktop.
          </p>
          <div className={styles.infoGrid}>
            <div className={styles.infoItem}>
              <span className={styles.infoLabel}>CloudFront base URL</span>
              <p className={styles.code}>{validBaseUrl}</p>
            </div>
            <div className={styles.infoItem}>
              <span className={styles.infoLabel}>Demo image path</span>
              <p className={styles.code}>{demoImagePath}</p>
            </div>
            <div className={styles.infoItem}>
              <span className={styles.infoLabel}>Loader params</span>
              <p className={styles.code}>
                format=auto
                <br />
                width=&lt;responsive value from next/image&gt;
                <br />
                quality={DEFAULT_IMAGE_QUALITY}
                <br />
                sizes={DEFAULT_IMAGE_SIZES}
              </p>
            </div>
            <div className={styles.infoItem}>
              <span className={styles.infoLabel}>Example generated URL</span>
              <p className={styles.code}>{exampleUrl}</p>
            </div>
          </div>
        </section>
      </div>
    </main>
  );
}
