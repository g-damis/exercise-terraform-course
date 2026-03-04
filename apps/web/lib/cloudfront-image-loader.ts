import type { ImageLoaderProps } from "next/image";

export const DEFAULT_IMAGE_QUALITY = 75;
export const DEFAULT_IMAGE_SIZES =
  "(max-width: 768px) 100vw, (max-width: 1280px) 88vw, 960px";

type BuildCloudFrontImageUrlArgs = ImageLoaderProps & {
  baseUrl?: string;
};

export function normalizeCloudFrontPath(src: string) {
  if (/^https?:\/\//i.test(src)) {
    throw new Error("CloudFrontImage expects a relative CloudFront path.");
  }

  return src.startsWith("/") ? src : `/${src}`;
}

export function buildCloudFrontImageUrl({
  src,
  width,
  quality = DEFAULT_IMAGE_QUALITY,
  baseUrl = process.env.NEXT_PUBLIC_IMAGE_CDN_BASE_URL,
}: BuildCloudFrontImageUrlArgs) {
  if (!baseUrl) {
    throw new Error("Missing NEXT_PUBLIC_IMAGE_CDN_BASE_URL.");
  }

  const normalizedSrc = normalizeCloudFrontPath(src);

  try {
    const url = new URL(normalizedSrc, baseUrl);

    url.searchParams.set("format", "auto");
    url.searchParams.set("width", String(width));
    url.searchParams.set("quality", String(quality));

    return url.toString();
  } catch {
    throw new Error(
      "NEXT_PUBLIC_IMAGE_CDN_BASE_URL must be a valid absolute URL.",
    );
  }
}

export default function cloudfrontImageLoader(props: ImageLoaderProps) {
  return buildCloudFrontImageUrl(props);
}
