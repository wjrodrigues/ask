import { describe, it, expect } from "vitest";
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

    expect(error_messages.length).toEqual(3);
    error_messages.map((msg) =>
      expect(msg.text()).toEqual("Campo é obrigatório")
    );
  });

  it("submit form button", async () => {
    const wrapper = mount(
      UserRegisterVue,
      basic_mount({ props: {}, plugins: [] })
    );

    expect(wrapper.find("button").attributes("disabled")).toBeUndefined;

    await wrapper.findAll("input").forEach(async (e) => e.setValue("Ask"));
    await wrapper.trigger("change");

    const data: any = wrapper.vm.$data;

    expect(data.form).toBeTruthy;
    expect(wrapper.find("button:disabled")).toBeNull;
    expect(wrapper.find("button").attributes("disabled")).toBeUndefined;
  });

  it("validates form submission errors", async () => {
    const wrapper = mount(
      UserRegisterVue,
      basic_mount({ props: {}, plugins: [] })
    );
    wrapper.find("[name='first_name']").setValue(faker.name.firstName());
    wrapper.find("[name='email']").setValue(faker.internet.email());
    wrapper.find("[name='password']").setValue(faker.internet.password());

    await wrapper.trigger("change");

    expect(wrapper.vm.errors).toEqual({
      first_name: "",
      email: "",
      password: "",
    });
    expect(wrapper.vm.form).toEqual(true);

    nock(base_urls.API_REGISTRATION)
      .post("/users")
      .reply(422, [{ email: ["já está em uso"] }]);

    await wrapper.find("form").trigger("submit");
  });
});
