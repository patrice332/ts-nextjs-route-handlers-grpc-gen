import { Logger, transports } from "winston";
// trunk-ignore(eslint/@typescript-eslint/no-unused-vars)
import { CodeGeneratorRequest } from "third_party/plugin_pb";

function main() {
  const logger = new Logger();
  logger.add(new transports.Console());

  logger.log("info", "Hello World!");
}

main();
