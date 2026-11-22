export type InstallOptions = {
  source: string;
  cwd?: string;
  global?: boolean;
  dest?: string;
  home?: string;
  check?: boolean;
  update?: boolean;
};
export function parseArgs(args: string[]): { global: boolean; dest: string | undefined; help: boolean; check?: boolean; update?: boolean };
export function installSkill(options: InstallOptions): Promise<{
  target: string;
  alreadyInstalled: boolean;
  updated?: boolean;
  differences?: string[];
}>;
