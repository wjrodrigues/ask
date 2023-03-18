import { describe, it, expect } from "vitest";

import { apiRegistration, authHttp, simpleHttp } from "@/lib/http";

import { nock } from "@/__tests__/help";

const env = import.meta.env;

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

describe("when to use auth instance", () => {
  it("sets authorization header", () => {
    localStorage.setItem("access_token", "123");

    expect(authHttp().defaults.headers["Authorization"]).toEqual("123");
  });

  it("redirect to / when not authenticated", async () => {
    nock(env.VITE_API_REGISTRATION_URL).post("/profile").reply(401);
    window.location.href = "/home";

    await authHttp().post("/profile");

    expect(window.location.href).toEqual("///");
  });

  it("does not redirect to / when is authenticated", async () => {
    nock(env.VITE_API_REGISTRATION_URL).post("/profile").reply(200);
    window.location.href = "/home";

    await authHttp().post("/profile");

    expect(window.location.href).toContain("home");
  });

  it("throws error when not redirect", async () => {
    nock(env.VITE_API_REGISTRATION_URL).post("/profile").reply(422);

    const error = await authHttp()
      .post("/profile")
      .catch((error) => ({
        status: error.response.status,
        code: error.code,
        message: error.message,
      }));

    const expected_error = {
      status: 422,
      code: "ERR_BAD_REQUEST",
      message: "Request failed with status code 422",
    };

    expect(error).toEqual(expected_error);
  });
});
