"use client";

import Image, { type ImageProps } from "next/image";

import cloudfrontImageLoader, {
  DEFAULT_IMAGE_QUALITY,
  DEFAULT_IMAGE_SIZES,
} from "@/lib/cloudfront-image-loader";

type CloudFrontImageProps = Omit<
  ImageProps,
  "loader" | "src" | "quality" | "sizes" | "priority"
> & {
  src: string;
  quality?: number;
  sizes?: string;
  priority?: boolean;
};

export function CloudFrontImage({
  alt,
  quality = DEFAULT_IMAGE_QUALITY,
  sizes = DEFAULT_IMAGE_SIZES,
  priority = true,
  ...props
}: CloudFrontImageProps) {
  return (
    <Image
      {...props}
      alt={alt}
      loader={cloudfrontImageLoader}
      priority={priority}
      quality={quality}
      sizes={sizes}
    />
  );
}
