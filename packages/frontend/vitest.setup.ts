import { config } from "@vue/test-utils";
import i18n from "./src/config/i18n";

config.global.plugins = [i18n];

global.CSS = { supports: () => false };
