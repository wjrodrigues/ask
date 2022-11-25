<template>
  <RouterView />
</template>

<script lang="ts">
export default {
  mounted() {
    const title = () => {
      let title = this.$route.meta.title;
      if (title != undefined) {
        title = this.$t(String(title));
        document.title = `${title} | Ask`;
      } else {
        document.title = "Ask";
      }
    };

    this.$router.afterEach(() => title());
  },
};
</script>

<style scoped></style>
