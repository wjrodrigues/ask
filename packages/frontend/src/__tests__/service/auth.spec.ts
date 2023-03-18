import { describe, it, expect } from "vitest";
import { nock } from "@/__tests__/help";
import { auth } from "@/service/auth";
const env = import.meta.env;
const AUTH_URL = `${env.VITE_API_REGISTRATION_URL}`;

describe("when request /token with valid parameters", () => {
  it("sets token in session store and returns true", async () => {
    const access_token = "Bm%hJN3h9mRkE8etsp1RZNq!^^xf*";
    const refresh_token = "KrLGpt753&!Me8d1xJqokp&!D291T2";

    nock(AUTH_URL).post("/users/auth").reply(200, {
      access_token,
      expires_in: 1800,
      refresh_expires_in: 1800,
      refresh_token,
      token_type: "Bearer",
      session_state: "d2c23b9c-3928-4200-b3dc-2b7d537dfd12",
      scope: "email profile",
    });

    const response = await auth("billie_harvey@bauch-hills.info", "123456789");
    expect(localStorage.getItem("access_token")).toBe(access_token);
    expect(localStorage.getItem("refresh_token")).toBe(refresh_token);
    expect(response).toBeTruthy;
  });
});

describe("when request /token with invalid parameters", () => {
  it("returns false", async () => {
    nock(AUTH_URL)
      .post("/users/auth")
      .reply(401, ["Invalid username or password"]);

    const response = await auth("billie_harvey@bauch-hills.info", "123");
    expect(response).toBeFalsy;
  });
});
