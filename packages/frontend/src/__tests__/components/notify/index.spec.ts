import { describe, it, expect, vi } from "vitest";

import notify from "@/components/notify";

describe("when is snackbar", () => {
  it("calls listening method", () => {
    const instance = { method: () => {} };
    const spy = vi.spyOn(instance, "method");

    notify.snackbar.listen(spy);
    notify.snackbar.call();

    expect(spy).toHaveBeenCalledTimes(1);
  });
});
