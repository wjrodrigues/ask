<template>
  <v-card class="mx-auto" width="344" :title="$t('signup.form.title')">
    <v-container>
      <v-form v-model="form" @submit.prevent="onSubmit">
        <v-text-field
          v-model="first_name"
          :readonly="loading"
          :rules="[required]"
          clearable
          type="text"
          :label="$t('form.user.profile.first_name')"
          variant="underlined"
        ></v-text-field>

        <v-text-field
          v-model="last_name"
          :readonly="loading"
          clearable
          type="text"
          :label="$t('form.user.profile.last_name')"
          variant="underlined"
        ></v-text-field>

        <v-text-field
          v-model="email"
          :readonly="loading"
          :rules="[required]"
          clearable
          type="email"
          label="Email"
          variant="underlined"
        ></v-text-field>

        <v-text-field
          v-model="password"
          :readonly="loading"
          :rules="[required]"
          clearable
          :label="$t('form.user.password')"
          type="password"
          variant="underlined"
        ></v-text-field>

        <v-card-actions>
          <v-btn
            :disabled="!form"
            :loading="loading"
            block
            type="submit"
            variant="tonal"
            rounded="pill"
          >
            {{ $t("form.save") }}
          </v-btn>
        </v-card-actions>
      </v-form>
    </v-container>
  </v-card>
</template>

<script lang="ts">
export default {
  data: () => ({
    form: false,
    first_name: null,
    last_name: null,
    email: null,
    password: null,
    loading: false,
  }),

  methods: {
    onSubmit() {
      this.loading = true;
    },
    required(v: String) {
      return !!v || this.$t("form.field_required");
    },
  },
};
</script>
