import { t, Trans } from "@lingui/macro";
import { cn } from "@reactive-resume/utils";

type Props = {
  className?: string;
};

export const Copyright = ({ className }: Props) => (
  <div
    className={cn(
      "prose prose-sm prose-zinc flex max-w-none flex-col gap-y-1 text-xs opacity-40 dark:prose-invert",
      className,
    )}
  >
    <span>{t`By the community, for the community.`}</span>
    <span>
      <Trans>
        A passion project by <a>Chaitanya Pokhriyal</a>
      </Trans>
    </span>
  </div>
);
