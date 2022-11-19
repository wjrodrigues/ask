<template>
  <RouterView />
</template>

<script lang="ts">
export default {
  watch: {
    $route(to) {
      document.title = `${this.$t(to.meta.title)} | Ask`;
    },
  },
};
</script>

<style scoped></style>
