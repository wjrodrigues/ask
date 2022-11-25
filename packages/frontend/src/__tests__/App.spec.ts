import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";

import AppVue from "@/App.vue";
import { basic_mount } from "./help";
import { createRouter, createWebHistory } from "vue-router";

describe("when render AppVue", () => {
  it("renders route component with title", async () => {
    const router = createRouter({
      history: createWebHistory(),
      routes: [
        {
          path: "/",
          component: { template: "Welcome" },
          meta: { title: "App" },
        },
      ],
    });

    const wrapper = mount(
      AppVue,
      basic_mount({ props: {}, plugins: [router] })
    );

    router.push("/");
    await router.isReady();

    expect(wrapper.text()).toEqual("Welcome");
    expect(wrapper.vm.$el.ownerDocument.title).toEqual("App | Ask");
  });

  it("renders route component without title", async () => {
    const router = createRouter({
      history: createWebHistory(),
      routes: [
        {
          path: "/",
          component: { template: "Welcome" },
          meta: {},
        },
      ],
    });

    const wrapper = mount(
      AppVue,
      basic_mount({ props: {}, plugins: [router] })
    );

    router.push("/");
    await router.isReady();

    expect(wrapper.text()).toEqual("Welcome");
    expect(wrapper.vm.$el.ownerDocument.title).toEqual("Ask");
  });
});
