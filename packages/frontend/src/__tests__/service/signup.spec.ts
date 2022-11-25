import { describe, it, expect } from "vitest";
import { signup } from "@/service/signup";
import { faker, nock, base_urls } from "@/__tests__/help";

describe("when request /users with valid parameters", () => {
  it("returns empty object", async () => {
    nock(base_urls.API_REGISTRATION).post("/users").reply(201);

    const response = await signup({
      first_name: faker.name.firstName(),
      last_name: faker.name.lastName(),
      email: faker.internet.email(),
      password: faker.internet.password(),
    });

    expect(response).toEqual({});
  });
});

describe("when request /users with invalid parameters", () => {
  it("returns empty object", async () => {
    const expected_response = [
      {
        email: ["não pode ficar em branco", "não é válido"],
      },
    ];

    const signup_params = {
      first_name: "",
      last_name: "",
      email: "",
      password: faker.internet.password(),
    };

    nock(base_urls.API_REGISTRATION)
      .post("/users")
      .reply(422, expected_response);

    const response = await signup(signup_params);

    expect(response).toEqual(expected_response);
  });
});
