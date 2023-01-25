import { createRouter, createWebHistory } from "vue-router";
import Signup from "../views/SignUp.vue";
import Signin from "../views/SignIn.vue";
import ProfileUpdaterVue from "../views/ProfileUpdater.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/signup",
      name: "signup",
      component: () => Signup,
      meta: {
        title: "signup.title",
      },
    },
    {
      path: "/signin",
      name: "signin",
      component: () => Signin,
      meta: {
        title: "signin.title",
      },
    },
    {
      path: "/profile",
      name: "profile",
      component: () => ProfileUpdaterVue,
      meta: {
        title: "profile.title",
      },
    },
  ],
});

export default router;
