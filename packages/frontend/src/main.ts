import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";

import "./assets/main.css";

// Vuetify
import "vuetify/styles";
import { createVuetify } from "vuetify";
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import i18n from "@/config/i18n";

const vuetify = createVuetify({
  components,
  directives,
});

createApp(App).use(i18n).use(vuetify).use(router).mount("#app");
