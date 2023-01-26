<template>
  <div class="h-screen">
    <div class="d-flex align-center justify-center h-75">
      <ProfileUpdater />
    </div>
  </div>
</template>

<script lang="ts">
import ProfileUpdater from "@/components/user/ProfileUpdater.vue";

export default {
  components: {
    ProfileUpdater,
  },
};
</script>
