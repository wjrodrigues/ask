import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";

import AppVue from "@/App.vue";

describe("when render AppVue", () => {
  it("it should work", () => {
    const wrapper = mount(AppVue, { props: {} });

    expect(wrapper.text()).toContain("Ola");
  });
});
