<template>
  <div class="h-screen">
    <div class="d-flex align-center justify-center h-75">
      <UserLogin />
    </div>
  </div>
</template>

<script lang="ts">
import UserLogin from "@/components/signin/UserLogin.vue";

export default {
  components: {
    UserLogin,
  },
};
</script>
