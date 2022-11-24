import { createVuetify } from "vuetify";
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import { faker } from "@faker-js/faker";
import nock from "nock";

interface Options {
  props: {};
  plugins: any[];
}

const vuetify = createVuetify({ components, directives });
const base_urls = {
  API_REGISTRATION: process.env.VITE_API_REGISTRATION_URL || "",
};
const basic_mount = (options: Options) => {
  const div = document.createElement("div");
  div.setAttribute("id", "root");
  document.body.innerHTML = "";
  document.body.appendChild(div);

  return {
    attachTo: document.body,
    global: {
      plugins: [vuetify, ...options.plugins],
    },
    props: options.props,
  };
};

export { vuetify, faker, nock, base_urls, basic_mount };
