import { createRouter, createWebHistory } from "vue-router";
import { session } from "@/service/auth";
import Signup from "../views/SignUp.vue";
import Signin from "../views/SignIn.vue";
import NotFound from "../views/NotFound.vue";
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
        guard: true,
      },
    },
    {
      path: "/:pathMatch(.*)*",
      name: "notFound",
      component: () => NotFound,
      meta: {
        title: "pages.not_found.title",
      },
    },
  ],
});

router.beforeEach((to) => {
  if (to.meta.guard == undefined) return true;
  if (session() == null) return router.push("/signin");

  return true;
});

export default router;
