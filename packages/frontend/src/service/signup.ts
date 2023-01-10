import { apiRegistration } from "@/lib/http";

interface ISignupForm {
  email: string;
  password: string;
}

interface ISignupResponse {
  message?: [];
  errors?: [];
}

const Signup = async (form: ISignupForm) => {
  return (await apiRegistration()
    .post("/users", form)
    .then(() => ({}))
    .catch((error) => ({ errors: error.response.data }))) as ISignupResponse;
};

export { Signup };
