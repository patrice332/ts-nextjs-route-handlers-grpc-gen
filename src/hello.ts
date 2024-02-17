import { Logger, transports } from "winston";

function main() {
  const logger = new Logger();
  logger.add(new transports.Console());
  logger.log("info", "Hello World!");
}

main();
