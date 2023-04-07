import { authHttp, simpleHttp } from "@/lib/http";

interface IProfile {
  first_name: string;
  last_name: string;
  photo: string | null;
}

interface IProfileResponse {
  message?: [];
  errors?: [];
}

const update = async (form: IProfile) => {
  return authHttp()
    .post("/users/profile", form)
    .then(() => true)
    .catch((error) => ({
      errors: error.response.data,
    })) as IProfileResponse;
};

const presignedURL = (extension: string) => {
  return authHttp()
    .post("/users/profile/presigned_url", {
      extension: extension,
    })
    .then((url) => url.data)
    .catch(() => false);
};

const uploadImage = (presignedURL: string, file: ArrayBuffer) => {
  return simpleHttp({ timeout: 3000 })
    .put(presignedURL, file, {
      headers: {
        "Content-Type": "application/octet-stream",
      },
    })
    .then(() => presignedURL)
    .catch(() => "");
};

const load = async () => {
  return (await authHttp()
    .get("/users/profile")
    .then((response) => response.data)
    .catch(() => ({}))) as IProfile;
};

export { update, presignedURL, uploadImage, load };
