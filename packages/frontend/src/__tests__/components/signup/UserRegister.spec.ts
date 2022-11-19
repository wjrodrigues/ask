import { describe, it, expect } from "vitest";
import { shallowMount, mount } from "@vue/test-utils";

import UserRegisterVue from "@/components/signup/UserRegister.vue";
import vuetify from "@/__tests__/help";

describe("when render UserRegisterVue", () => {
  it("render form with all components", () => {
    const wrapper = shallowMount(UserRegisterVue, { props: {} });

    expect(wrapper.element).toMatchSnapshot();
  });

  it("validate required input", async () => {
    const wrapper = mount(UserRegisterVue, {
      props: {},
      global: {
        plugins: [vuetify],
      },
    });

    await wrapper.findAll("input").forEach(async (e) => e.setValue(""));
    await wrapper.trigger("change");

    const error_messages = await wrapper.findAll(".v-messages > div");

    expect(error_messages.length).toEqual(3);
    error_messages.map((msg) =>
      expect(msg.text()).toEqual("Campo é obrigatório")
    );
  });

  it("submit form button", async () => {
    const wrapper = mount(UserRegisterVue, {
      props: {},
      global: {
        plugins: [vuetify],
      },
    });

    expect(wrapper.find("button").attributes("disabled")).toEqual("");

    await wrapper.findAll("input").forEach(async (e) => e.setValue("Ask"));
    await wrapper.trigger("change");

    const data: any = wrapper.vm.$data;

    expect(data.form).toBeTruthy;
    expect(wrapper.find("button:disabled")).toBeNull;
    expect(wrapper.find("button").attributes("disabled")).toBeUndefined;
  });
});
