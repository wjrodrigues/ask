import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";

import ProfileUpdaterVue from "@/views/ProfileUpdater.vue";
import { basic_mount } from "@/__tests__/help";

describe("when render ProfileUpdaterVue", () => {
  it("render form with all components", () => {
    const wrapper = mount(
      ProfileUpdaterVue,
      basic_mount({ props: {}, plugins: [] })
    );

    expect(wrapper.element).toMatchSnapshot();
  });

  it("validate required input", async () => {
    const wrapper = mount(
      ProfileUpdaterVue,
      basic_mount({ props: {}, plugins: [] })
    );

    const inputs = await wrapper.findAll("input[type='text']");
    await inputs.forEach(async (e) => e.setValue("1"));
    await inputs.forEach(async (e) => e.setValue(""));
    await wrapper.trigger("change");

    const error_messages = await wrapper.findAll(".v-messages > div");
    expect(error_messages.length).toEqual(1);
    error_messages.map((msg) =>
      expect(msg.text()).toEqual("Campo é obrigatório")
    );
  });

  it("preview image supported", async () => {
    const wrapper = mount(
      ProfileUpdaterVue,
      basic_mount({ props: {}, plugins: [] })
    );

    await wrapper.find("button").trigger("click");
    const inputFile = await wrapper.find("input[name='photo']");

    expect(inputFile.attributes("type")).toEqual("file");
    const inputElement = inputFile.element as HTMLInputElement;

    inputElement.files = [
      new File([new ArrayBuffer(1)], "file.jpg", {
        type: "image/jpg",
      }),
    ] as unknown as FileList;

    await inputFile.trigger("change");

    const preview = await wrapper.find("img");
    expect(preview.element.classList.toString()).toEqual("preview-photo");
  });

  it("do not preview image", async () => {
    const wrapper = mount(
      ProfileUpdaterVue,
      basic_mount({ props: {}, plugins: [] })
    );

    const inputFile = await wrapper.find("input[name='photo']");
    const inputElement = inputFile.element as HTMLInputElement;

    inputElement.files = [
      new File([new ArrayBuffer(1)], "file.tiff", {
        type: "image/tiff",
      }),
    ] as unknown as FileList;

    await inputFile.trigger("change");

    const preview = await wrapper.find("img");
    expect(preview.element.classList.toString()).toEqual(
      "d-none preview-photo"
    );
  });
});
