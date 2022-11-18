import { describe, it, expect, vi } from "vitest";
import { mount} from "@vue/test-utils";

import AppVue from "@/App.vue";

describe("when render AppVue", () => {
  it("it empty page", () => {
    const wrapper = mount(AppVue, { props: {} });

    expect(wrapper.text()).toEqual('')
  });

  it("calls method to set title", () => {
    const wrapper = mount(AppVue, { props: {} });
    const watch: any = wrapper.vm.$options.watch
    const spyObject = { $t: (msg: String) => { msg }, }

    watch.$t = vi.spyOn(spyObject, '$t').mockImplementation(() => { "App test"})
    watch['$route']({ meta: {title: 'app.test'} })

    expect(watch.$t).toHaveBeenCalled()
  })
});
