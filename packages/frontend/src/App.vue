<template>
  <RouterView />

  <SnackBar />
</template>

<script lang="ts">
import SnackBar from "@/components/notify/SnackBar.vue";

export default {
  mounted() {
    this.$router.afterEach(() => this.title());
  },
  methods: {
    title: function () {
      let title = this.$route.meta.title;
      if (title != undefined) {
        title = this.$t(String(title));
        document.title = `${title} | Ask`;
      } else {
        document.title = "Ask";
      }
    },
  },
  components: { SnackBar },
};
</script>

<style scoped></style>
