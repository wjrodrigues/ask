<template>
  <div class="h-screen">
    <div class="d-flex align-center justify-center h-75">
      <UserRegister />
    </div>
  </div>
</template>

<script lang="ts">
import UserRegister from "@/components/signup/UserRegister.vue";

export default {
  components: {
    UserRegister,
  },
};
</script>
