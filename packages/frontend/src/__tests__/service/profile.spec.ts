import { describe, it, expect } from "vitest";
import { base_urls, faker, nock } from "@/__tests__/help";
import { presignedURL, update, uploadImage, load } from "@/service/profile";

describe("when profile is updated", () => {
  it("returns true if successful", async () => {
    const form = {
      first_name: faker.name.firstName(),
      last_name: faker.name.lastName(),
      photo: `${faker.datatype.uuid()}.png`,
    };

    nock(base_urls.API_REGISTRATION).post("/users/profile").reply(200);

    const response = await update(form);
    expect(response).toEqual(true);
  });

  it("returns errors if invalid payload", async () => {
    const form = {
      first_name: "",
      last_name: faker.name.lastName(),
      photo: null,
    };

    const expected_response = {
      errors: [
        {
          first_name: ["can't be blank"],
        },
      ],
    };

    nock(base_urls.API_REGISTRATION)
      .post("/users/profile")
      .reply(422, [{ first_name: ["can't be blank"] }]);

    const response = await update(form);

    expect(response).toEqual(expected_response);
  });
});

describe("when request presigned URL", () => {
  it("returns valid URL", async () => {
    nock(base_urls.API_REGISTRATION)
      .post("/users/profile/presigned_url")
      .reply(
        200,
        "http://localhost/profilepictures/57825751-5412-4327-87de-dbcec6a52ef7.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256"
      );

    const response = await presignedURL("jpg");
    expect(response).toString;
  });

  it("returns false when invalid request", async () => {
    nock(base_urls.API_REGISTRATION)
      .post("/users/profile/presigned_url")
      .reply(422);

    const response = await presignedURL("jpg");
    expect(response).toBeFalsy;
  });
});

describe("when loading profile picture", () => {
  const base = "http://localhost";
  const path =
    "/profilepictures/57825751-5412-4327-87de-dbcec6a52ef7.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256";
  const presignedURL = [base, path].join("");

  it("returns presigned URL when valid", async () => {
    nock(base).put(path).reply(200);

    const response = await uploadImage(presignedURL, new ArrayBuffer(200));
    expect(response).toEqual(presignedURL);
  });

  it("returns empty when invalid", async () => {
    nock(base).put(path).reply(422);

    const response = await uploadImage(presignedURL, new ArrayBuffer(200));
    expect(response).toEqual("");
  });
});

describe("when there is profile information", () => {
  it("returns informations", async () => {
    const expected = {
      first_name: faker.name.firstName(),
      last_name: faker.name.lastName(),
      photo: "http://localhos/123.png",
    };
    nock(base_urls.API_REGISTRATION).get("/users/profile").reply(200, expected);

    const response = await load();

    expect(response).toEqual(expected);
  });
});
