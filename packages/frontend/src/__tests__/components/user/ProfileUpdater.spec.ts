import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";

import ProfileUpdater from "@/components/user/ProfileUpdater.vue";
import { basic_mount, faker, base_urls, nock } from "@/__tests__/help";

describe("when render", () => {
  it("render form with all components", () => {
    const wrapper = mount(
      ProfileUpdater,
      basic_mount({ props: {}, plugins: [] })
    );

    expect(wrapper.element).toMatchSnapshot();
  });

  it("validate required input", async () => {
    const wrapper = mount(
      ProfileUpdater,
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
      ProfileUpdater,
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
      ProfileUpdater,
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

describe("when submit form", () => {
  it("validates form errors", async () => {
    const wrapper = mount(
      ProfileUpdater,
      basic_mount({ props: {}, plugins: [] })
    );

    await wrapper.find("[name='first_name']").setValue(faker.name.firstName());
    await wrapper.find("[name='first_name']").setValue("");
    await wrapper.trigger("change");

    const error_messages = await wrapper.findAll(".v-messages > div");
    expect(error_messages[0].text()).toEqual("Campo é obrigatório");

    expect(wrapper.vm.errors).toEqual({
      first_name: "",
      last_name: "",
      photo: "",
    });
    expect(wrapper.vm.form).toEqual(false);
  });

  it("sends only first name", async () => {
    nock(base_urls.API_REGISTRATION).post("/users/profile").reply(200);

    const wrapper = mount(
      ProfileUpdater,
      basic_mount({ props: {}, plugins: [] })
    );

    await wrapper.find("[name='first_name']").setValue(faker.name.firstName());
    await wrapper.trigger("change");
    await wrapper.find("form").trigger("submit");

    const error_messages = await wrapper.findAll(".v-messages > div");
    expect(error_messages).toHaveLength(0);
  });

  it("sends with photo", async () => {
    nock(base_urls.API_REGISTRATION).post("/users/profile").reply(200);
    nock(base_urls.API_REGISTRATION)
      .post("/users/profile/presigned_url")
      .reply(
        200,
        "http://localhost/profilepictures/57825751-5412-4327-87de-dbcec6a52ef7.jpg?X-Amz"
      );
    nock("http://localhost")
      .put("/profilepictures/57825751-5412-4327-87de-dbcec6a52ef7.jpg?X-Amz")
      .reply(200);

    const wrapper = mount(
      ProfileUpdater,
      basic_mount({ props: {}, plugins: [] })
    );

    await wrapper.find("[name='first_name']").setValue(faker.name.firstName());

    const inputFile = await wrapper.find("input[name='photo']");
    const inputElement = inputFile.element as HTMLInputElement;

    inputElement.files = [
      new File([new ArrayBuffer(1)], "file.jpg", { type: "image/jpg" }),
    ] as unknown as FileList;

    await wrapper.find("form").trigger("submit");

    const error_messages = await wrapper.findAll(".v-messages > div");
    expect(error_messages).toHaveLength(0);
  });

  it("updates profile error", async () => {
    nock(base_urls.API_REGISTRATION).post("/users/profile").reply(500);

    const wrapper = mount(
      ProfileUpdater,
      basic_mount({ props: {}, plugins: [] })
    );

    await wrapper.find("[name='first_name']").setValue(faker.name.firstName());
    await wrapper.trigger("change");
    await wrapper.find("form").trigger("submit");
  });
});
