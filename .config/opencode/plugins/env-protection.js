const READ_VERBS = [
  // Unix
  "cat","less","more","head","tail","nano","vim","vi","view","sed","awk",
  "grep","egrep","fgrep","rg","strings","od","xxd","hexdump","paste","sort",
  "uniq","base64","openssl","sha1sum","sha256sum","sha512sum","md5sum","wc",
  "fold","pr","tac","rev","nl","fmt","diff","cmp","comm","cut",
  "source","dd","xargs","cp","mv","scp","rsync","curl","wget","tar","zip",
  "7z","unzip",
  // Windows / PowerShell
  "type","findstr","comp","expand","copy","xcopy","robocopy","move","certutil",
  "get-content","gc","select-string","get-filehash","import-csv","format-hex",
  // .NET
  "readalltext","readallbytes","readalllines","streamreader","openread",
  // Interpreters
  "node","bun","deno","python","python3","perl","ruby","php","dotenv",
  // git subcommands that print content
  String.raw`git\s+(?:show|diff|grep|log|blame|cat-file)`,
].join("|");

const TEMPLATE = String.raw`\.(?:example|sample|dist|template)\b`;

const ENV_NAME = String.raw`\.env(?!${TEMPLATE})(?:\.[A-Za-z0-9_-]+)*(?=[\s"'/\`;:&|>)=,}]|$)`;

const RE_READ = new RegExp(
  [
    String.raw`\b(?:${READ_VERBS})\b[^\n|;&]*?${ENV_NAME}`,
    String.raw`<\s*${ENV_NAME}`,
    String.raw`(?:^|[\n;&|])\s*\.\s+${ENV_NAME}`,
  ].join("|"),
  "i"
);

const RE_READ_PATH = new RegExp(
  String.raw`\.env(?!${TEMPLATE}$)(?:\.[A-Za-z0-9_-]+)*$`,
  "i"
);

// cp/mv de una plantilla .env.* a un .env real no expone secretos: se exceptúa
const RE_TEMPLATE_COPY = new RegExp(
  String.raw`\b(?:cp|mv|copy|move)\b[^\n;|&]*?\.env(?:\.[A-Za-z0-9_-]+)*?${TEMPLATE}\s+[^\n;|&]*?${ENV_NAME}`,
  "gi"
);

// Local plugins cannot resolve the "@opencode/plugin" package from the config
// directory, so export the plugin definition object directly.
// Equivalent to Plugin.define({ id, setup }) from that package.
export default {
  id: "env-protection",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", (event) => {
      const input = event.input ?? {};

      if (
        event.tool === "read" &&
        typeof input.path === "string" &&
        RE_READ_PATH.test(input.path)
      ) {
        throw new Error("Do not read .env files");
      }
      if (
        event.tool === "shell" &&
        typeof input.command === "string"
      ) {
        const cmd = input.command
          .replace(/['"`]+/g, "")
          .replace(RE_TEMPLATE_COPY, "");
        if (RE_READ.test(cmd)) {
          throw new Error(
            "Command appears to read a .env file. Refusing to execute."
          );
        }
      }
    });
  },
};
