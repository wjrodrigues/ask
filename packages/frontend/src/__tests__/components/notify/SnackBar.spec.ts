import { describe, it, expect } from "vitest";
import { mount, shallowMount } from "@vue/test-utils";

import SnackBar from "@/components/notify/SnackBar.vue";
import notify from "@/components/notify";
import { basic_mount } from "@/__tests__/help";
import { VBtn } from "vuetify/components";

describe("when render SnackBar", () => {
  it("render SnackBar with text", async () => {
    const wrapper = await shallowMount(
      SnackBar,
      basic_mount({ props: {}, plugins: [] })
    );
    await notify.snackbar.call("Vue App");
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.$data).toEqual({
      snackbar: true,
      timeout: 5000,
      text: "Vue App",
    });
    expect(wrapper.html()).toMatchSnapshot();
  });

  it("does not render SnackBar when empty text", async () => {
    const wrapper = await shallowMount(
      SnackBar,
      basic_mount({ props: {}, plugins: [] })
    );
    await notify.snackbar.call("");
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.$data).toEqual({
      snackbar: false,
      timeout: 5000,
      text: "",
    });
    expect(wrapper.html()).toMatchSnapshot();
  });

  it("updates data if click the close button", async () => {
    const wrapper = await mount(
      SnackBar,
      basic_mount({ props: {}, plugins: [] })
    );

    await notify.snackbar.call("Vue App");
    expect(wrapper.vm.$data).toEqual({
      snackbar: true,
      timeout: 5000,
      text: "Vue App",
    });

    const btnClose = wrapper.findComponent(VBtn);
    await btnClose.trigger("click");

    expect(wrapper.vm.$data).toEqual({
      snackbar: false,
      timeout: 5000,
      text: "",
    });
  });
});
