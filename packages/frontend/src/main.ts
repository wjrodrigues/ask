import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";

import "./assets/main.css";
import i18n from "@/config/i18n";
import vuetify from "@/config/vuetify";

createApp(App).use(i18n).use(vuetify).use(router).mount("#app");
