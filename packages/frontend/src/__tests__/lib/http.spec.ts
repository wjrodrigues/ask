import { describe, it, expect } from "vitest";

import { apiRegistration, simpleHttp } from "@/lib/http";

describe("when to use simple instance", () => {
  it("does not define base url", () => {
    expect(simpleHttp().defaults.baseURL).toBeUndefined;
  });
});

describe("when to use API registration", () => {
  it("sets base url", () => {
    expect(apiRegistration().defaults.baseURL).toEqual(
      process.env.VITE_API_REGISTRATION_URL
    );
  });
});
