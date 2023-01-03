import { describe, it, expect, vi } from "vitest";
import { mount, shallowMount } from "@vue/test-utils";

import UserLoginVue from "@/components/signin/UserLogin.vue";
import { base_urls, basic_mount, faker, nock } from "@/__tests__/help";

describe("when render UserLoginVue", () => {
  it("render form with all components", () => {
    const wrapper = shallowMount(
      UserLoginVue,
      basic_mount({ props: {}, plugins: [] })
    );

    expect(wrapper.element).toMatchSnapshot();
  });

  it("validate required input", async () => {
    const wrapper = mount(
      UserLoginVue,
      basic_mount({ props: {}, plugins: [] })
    );

    await wrapper.findAll("input").forEach(async (e) => e.setValue(""));
    await wrapper.trigger("change");

    const error_messages = await wrapper.findAll(".v-messages > div");

    expect(error_messages.length).toEqual(2);
    error_messages.map((msg) =>
      expect(msg.text()).toEqual("Campo é obrigatório")
    );
  });

  it("submit form button", async () => {
    const wrapper = mount(
      UserLoginVue,
      basic_mount({ props: {}, plugins: [] })
    );

    wrapper.find("[name='email']").setValue(faker.internet.email());
    wrapper.find("[name='password']").setValue(faker.internet.password());

    await wrapper.trigger("change");

    expect(wrapper.vm.errors).toEqual({
      email: "",
      password: "",
    });
    expect(wrapper.vm.form).toEqual(true);
    await wrapper.find("form").trigger("submit");
  });

  it("go to sign up", async () => {
    const spyPush = { push: () => {} };
    const spy = vi.spyOn(spyPush, "push");

    const wrapper = mount(
      UserLoginVue,
      basic_mount({
        props: {},
        plugins: [],
        mocks: {
          $router: {
            push: spy,
          },
        },
      })
    );

    const signin = wrapper.findAll("button")[0];
    expect(signin.text()).toEqual("Inscrever-se");

    await signin.trigger("click");
    await wrapper.trigger("change");

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith("/signup");
  });
});
