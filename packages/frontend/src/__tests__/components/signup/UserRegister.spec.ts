import { describe, it, expect, vi } from "vitest";
import { shallowMount, mount } from "@vue/test-utils";

import UserRegisterVue from "@/components/signup/UserRegister.vue";
import { base_urls, basic_mount, faker, nock } from "@/__tests__/help";

describe("when render UserRegisterVue", () => {
  it("render form with all components", () => {
    const wrapper = shallowMount(
      UserRegisterVue,
      basic_mount({ props: {}, plugins: [] })
    );

    expect(wrapper.element).toMatchSnapshot();
  });

  it("validate required input", async () => {
    const wrapper = mount(
      UserRegisterVue,
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
    const spyPush = { push: () => {} };
    const spy = vi.spyOn(spyPush, "push");

    const wrapper = mount(
      UserRegisterVue,
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

    nock(base_urls.API_REGISTRATION).post("/users").reply(200);

    await wrapper.find("input[type='email']").setValue(faker.internet.email());
    await wrapper
      .find("input[type='password']")
      .setValue(faker.internet.password());
    await wrapper.trigger("change");

    await wrapper.find("form").trigger("submit");
    await wrapper.trigger("change");
  });

  it("validates form submission errors", async () => {
    const wrapper = mount(
      UserRegisterVue,
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

    nock(base_urls.API_REGISTRATION)
      .post("/users")
      .reply(422, [{ email: ["já está em uso"] }]);

    await wrapper.find("form").trigger("submit");
  });

  it("go to sign in", async () => {
    const spyPush = { push: () => {} };
    const spy = vi.spyOn(spyPush, "push");

    const wrapper = mount(
      UserRegisterVue,
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
    expect(signin.text()).toEqual("Entrar");

    await signin.trigger("click");
    await wrapper.trigger("change");

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith("/signin");
  });
});
