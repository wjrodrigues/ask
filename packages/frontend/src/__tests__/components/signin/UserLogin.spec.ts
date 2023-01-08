import { describe, it, expect, vi } from "vitest";
import { mount, shallowMount } from "@vue/test-utils";

import UserLogin from "@/components/signin/UserLogin.vue";
import { basic_mount, faker, nock } from "@/__tests__/help";

const env = import.meta.env;
const AUTH_URL = `${env.VITE_AUTH_URL}/realms/${env.VITE_AUTH_REALM}/protocol/openid-connect`;

describe("when render UserLogin", () => {
  it("render form with all components", () => {
    const wrapper = shallowMount(
      UserLogin,
      basic_mount({ props: {}, plugins: [] })
    );

    expect(wrapper.element).toMatchSnapshot();
  });

  it("validate required input", async () => {
    const wrapper = mount(UserLogin, basic_mount({ props: {}, plugins: [] }));

    await wrapper.findAll("input").forEach(async (e) => e.setValue(""));
    await wrapper.trigger("change");

    const error_messages = await wrapper.findAll(".v-messages > div");

    expect(error_messages.length).toEqual(2);
    error_messages.map((msg) =>
      expect(msg.text()).toEqual("Campo é obrigatório")
    );
  });

  it("submit form button", async () => {
    nock(AUTH_URL).post("/token").reply(200, {
      access_token: "Bm%hJN3h9mRkE8etsp1RZNq!^^xf*",
      expires_in: 1800,
      refresh_expires_in: 1800,
      refresh_token: "Bm%hJN3h9mRkE8etsp1RZNq!^^xf*",
      token_type: "Bearer",
      session_state: "d2c23b9c-3928-4200-b3dc-2b7d537dfd12",
      scope: "email profile",
    });
    const wrapper = mount(UserLogin, basic_mount({ props: {}, plugins: [] }));

    wrapper.find("[name='email']").setValue(faker.internet.email());
    wrapper.find("[name='password']").setValue(faker.internet.password());

    await wrapper.trigger("change");
    await wrapper.find("form").trigger("submit");
    await wrapper.vm.$nextTick();

    expect(await wrapper.vm.errors).toEqual({
      email: "",
      password: "",
    });
    expect(await wrapper.vm.form).toEqual(true);
    expect(await wrapper.vm.loading).toEqual(true);
  });

  it("go to sign up", async () => {
    const spyPush = { push: () => {} };
    const spy = vi.spyOn(spyPush, "push");

    const wrapper = mount(
      UserLogin,
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

  it("returns invalid email or password", async () => {
    nock(AUTH_URL).post("/token").reply(401);

    const wrapper = mount(UserLogin, basic_mount({ props: {}, plugins: [] }));

    wrapper.find("[name='email']").setValue(faker.internet.email());
    wrapper.find("[name='password']").setValue(faker.internet.password());

    await wrapper.trigger("change");
    await wrapper.vm.onSubmit();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.errors).toEqual({
      email: "Dados inválidos",
      password: "Dados inválidos",
    });
    expect(wrapper.vm.loading).toEqual(false);
    expect(wrapper.findAll(".v-messages__message")).toHaveLength(2);
  });
});
