const READ_VERBS = [
  "cat","less","more","head","tail","nano","vim","vi","view","sed","awk",
  "grep","egrep","fgrep","rg","strings","od","xxd","hexdump","paste","sort",
  "uniq","base64","openssl","sha1sum","sha256sum","sha512sum","md5sum","wc",
  "fold","pr","tac","rev","nl","fmt","diff","cmp","comm","cut",
  "type","findstr","comp","expand",
  "get-content","gc","select-string","get-filehash","import-csv","format-hex",
].join("|");

const ENV_NAME = String.raw`\.env(?:\.[A-Za-z0-9_-]+)?(?=[\s"'/\`;:&|>)}]|$)`;

const RE_READ = new RegExp(
  String.raw`\b(?:${READ_VERBS})\b[^\n|;&]*?${ENV_NAME}`,
  "i"
);

export const EnvProtection = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (
        input.tool === "read" &&
        /\.env(?:\.[A-Za-z0-9_-]+)?$/i.test(output.args.filePath)
      ) {
        throw new Error("Do not read .env files");
      }
      if (input.tool === "bash" && output.args?.command) {
        const cmd = output.args.command.replace(/['"`]+/g, "");
        if (RE_READ.test(cmd)) {
          throw new Error(
            "Command appears to read a .env file. Refusing to execute."
          );
        }
      }
    },
  };
};
