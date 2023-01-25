<template>
  <v-card class="mx-auto" width="344" :title="$t('profile.title')">
    <v-container>
      <v-form v-model="form" @submit.prevent="">
        <v-row justify="center">
          <input
            class="d-none"
            type="file"
            name="photo"
            ref="photo"
            accept="image/png, image/gif, image/jpeg, image/ico, image/jpg"
            @change="preloadPhoto"
          />

          <v-col cols="4">
            <v-avatar color="info" size="64">
              <img
                ref="previewPhoto"
                src=""
                :class="{ 'd-none': !photo }"
                class="preview-photo"
              />
              <v-icon icon="fas fa-user" :class="{ 'd-none': photo }"></v-icon>
            </v-avatar>

            <br />

            <v-btn variant="plain" @click="selectPhoto" :disabled="loading">
              {{ $t("profile.form.photo") }}
            </v-btn>
          </v-col>
        </v-row>

        <v-text-field
          v-model="first_name"
          :readonly="loading"
          :rules="[required]"
          clearable
          :label="$t('profile.first_name')"
          type="text"
          variant="underlined"
          :error-messages="errors.first_name"
          name="first_name"
        ></v-text-field>

        <v-text-field
          v-model="last_name"
          :readonly="loading"
          clearable
          :label="$t('profile.last_name')"
          type="text"
          variant="underlined"
          :error-messages="errors.last_name"
          name="last_name"
        ></v-text-field>

        <v-card-actions>
          <v-row justify="end">
            <v-btn
              type="submit"
              :disabled="loading"
              :loading="loading"
              color="success"
            >
              {{ $t("form.save") }}
            </v-btn>
          </v-row>
        </v-card-actions>
      </v-form>
    </v-container>
  </v-card>
</template>

<script lang="ts">
export default {
  data: () => ({
    form: false,
    first_name: "",
    last_name: "",
    url_photo: "",
    photo: false,
    loading: false,
    errors: { first_name: "", last_name: "", photo: "" },
  }),
  methods: {
    required(value: String) {
      return !!value || this.$t("form.field_required");
    },
    selectPhoto() {
      const inputPhoto = this.$refs.photo as HTMLInputElement;
      inputPhoto.click();
    },
    preloadPhoto(event: Event) {
      const target = event.target as HTMLInputElement;
      const files = target.files;

      if (files && files.length > 0) {
        const targetElement = this.$refs.previewPhoto as HTMLImageElement;
        const file = files[0];

        if (this.validFile(file)) {
          this.preview(file, targetElement);
          this.photo = true;
        }
      }
    },
    preview(file: File, targetElement: HTMLImageElement) {
      let reader = new FileReader();

      reader.readAsDataURL(file);
      reader.onload = () => {
        targetElement.src = `${reader.result}`;
      };
    },
    validFile(file: File) {
      const extension = file.name.split(".").pop() || "";

      return ["png", "jpeg", "ico", "gif", "jpg"].includes(extension);
    },
  },
};
</script>

<style>
.preview-photo {
  width: 100%;
  height: 100%;
}
</style>
